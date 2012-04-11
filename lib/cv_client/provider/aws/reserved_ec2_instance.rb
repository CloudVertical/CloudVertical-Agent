module CvClient
  module Provider
    module Aws
      class ReservedEC2Instance < CvClient::Provider::Aws::Base
        
        RESOURCE_TYPE = 'reserved_ec2_instance'
        PATH = "/v01/generics.json"
        
        def initialize()
          super
        end
                
        def fetch_data
          data = {}
          marked_as_reserved = JSON.parse(connection.get('/v01/computes?with_tags[]=reserved&format=json').body)
          REGIONS.each do |region|
            ec2 = RightAws::Ec2.new(@access_key_id, @secret_access_key, :region => region)
            reserved_instances = ec2.describe_reserved_instances
            _reserved_instances = []
            reserved_instances.each do |reserved_instance|
              @data << parse_data(reserved_instance)
              if reserved_instance[:aws_state] == 'active' or true
                _reserved_instances << reserved_instance
              end
            end
            if _reserved_instances.size > 0
              # _instances = ec2.describe_instances
              data[region] = _reserved_instances#{:reserved => _reserved_instances, :instances => _instances}
            end
          end
          p data
          data.each do |region, _reserved_instances|
            _instances = nil
            _reserved_instances.each do |reserved|
              reserved[:aws_instance_count].times do 
                instance_resources = INSTANCE_TYPES[reserved[:aws_instance_type]]
                if _inst = marked_as_reserved.find{|instance| instance[:location] == region && 
                                                              instance[:cpu] == instance_resources[:cpu] && 
                                                              instance[:ram] == instance_resources[:ram] && 
                                                              /#{instance[:platform]}/i.match(reserved[:aws_product_description])}
                  puts "ALREADY EXISTS"
                  marked_as_reserved.delete(_inst)
                else
                  puts "NEW NEW NEW NEW NEW NEW"
                  
                  ec2 = RightAws::Ec2.new(@access_key_id, @secret_access_key, :region => region)
                  _instances ||= ec2.describe_instances

                  _inst = _instances.find{|instance| instance[:aws_instance_type] == reserved[:aws_instance_type] && 
                                                     instance[:aws_availability_zone] == reserved[:aws_availability_zone] &&
                                                     /#{instance[:platform] ? 'windows' : 'linux'}/i.match(reserved[:aws_product_description]) &&
                                                     instance[:aws_state] == 'running'}
                  p _inst = _instances[0]
                  if _inst
                    _instances.delete(_inst)
                    connection.post({:data => [{:location => region, 
                                                :reference_id => _inst[:aws_instance_id], 
                                                :provider => PROVIDER, 
                                                :tags => ['reserved'],
                                                :currency => 'USD',
                                                :interval => 3600,
                                                :cost => reserved[:aws_usage_price],
                                                :compute_type => CvClient::Provider::Aws::EC2Instance::RESOURCE_TYPE}]}, "/v01/computes.json")
                    
                  end
                end
              end
            end
          end
          
          # 4 unsign tags
          
        end
        
        def parse_data(reserved_instance)
          return {:provider => PROVIDER,
                  :generic_type => RESOURCE_TYPE,
                  :reference_id => reserved_instance[:aws_id],
                  :location => reserved_instance[:aws_availability_zone],
                  :status => reserved_instance[:aws_state],
                  :cost => reserved_instance[:aws_fixed_price],
                  :currency => 'USD',
                  :interval => reserved_instance[:aws_duration],
                  :tags => parse_tags(reserved_instance[:tags].values)}
        end
                
        def send
          connection.post({:data => @data}, PATH)
        end

      end
    end
  end
end