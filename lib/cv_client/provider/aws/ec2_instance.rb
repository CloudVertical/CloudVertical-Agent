module CvClient
  module Provider
    module Aws
      class EC2Instance < CvClient::Provider::Aws::Base
        
        RESOURCE_TYPE = 'instance'
        INSTANCE_STATUSES = {'running' => 'running', 'stopped' => 'stopped'}
        PATH = "/v01/computes.json"
        
        def initialize()
          super
        end
                
        def fetch_data
          data = {:provider => PROVIDER, :compute_type => RESOURCE_TYPE}
          REGIONS.each do |region|
            data.merge!(:location => region)
            ec2 = RightAws::Ec2.new(@access_key_id, @secret_access_key, :region => region)
            instances = ec2.describe_instances
            instances.each do |instance|
              @data << parse_data(instance).merge(data)
            end
          end
          p @data
        end
        
        def parse_data(instance)
          p instance
          platform = instance.has_key?(:platform) ? 'windows' : 'linux'
          resources = INSTANCE_TYPES[instance[:aws_instance_type]]
          return {'reference_id' => instance[:aws_instance_id], 
                  'platform' => platform,
                  'status' => INSTANCE_STATUSES[instance[:aws_state]],
                  'hypervisor' => instance[:hypervisor],
                  'architecture' => instance[:architecture],
                  'tags' => parse_tags(instance[:tags].values.insert(0, instance[:aws_instance_type]))}.merge(resources)
        end
                
        def send
          @connection = CvClient::Core::Connection.new
          @connection.post({:data => @data}, PATH)
        end

      end
    end
  end
end