module CvClient
  module Provider
    module Aws
      class RdsInstance < CvClient::Provider::Aws::Base
        
        RESOURCE_TYPE = 'rds_instance'
        INSTANCE_STATUSES = {'running' => 'running', 'stopped' => 'stopped', 'available' => 'available'}
        PATH = "/v01/computes.json"
        INSTANCE_TYPES = {"db.m1.small"   => {'cpu' => 1,   'ram' => 1.7},
                          'db.m1.large'   => {'cpu' => 4,   'ram' => 7.5},
                          "db.m1.xlarge"  => {'cpu' => 8,   'ram' => 15},
                          "db.m2.xlarge"  => {'cpu' => 6.5, 'ram' => 17.1},
                          "db.m2.2xlarge" => {'cpu' => 13,  'ram' => 34},
                          "db.m2.4xlarge" => {'cpu' => 26,  'ram' => 68}
                          }
        
        def initialize()
          super
        end
                
        def fetch_data
          data = {:provider => PROVIDER, :compute_type => RESOURCE_TYPE}
          REGIONS.each do |region|
            data.merge!(:location => region)
            rds = RightAws::RdsInterface.new(@access_key_id, @secret_access_key, :endpoint => "http://rds.#{region}.amazonaws.com:443")
            instances = rds.describe_db_instances
            instances.each do |instance|
              @data << parse_data(instance).merge(data)
            end
          end
          p @data
        end
        
        def parse_data(instance)
          storage = instance[:allocated_storage]
          resources = INSTANCE_TYPES[instance[:instance_class]].merge(:storage => storage)
          return {'reference_id' => instance[:aws_id], 
                  'platform' => 'linux',
                  'status' => INSTANCE_STATUSES[instance[:status]],
                  'launch_time' => instance[:create_time],
                  'tags' => parse_tags([MAP_INSTANCE_TYPES[instance[:instance_class]]])}.merge(resources)
    
        end

        def send
          @connection = CvClient::Core::Connection.new
          @connection.post({:data => @data}, PATH)
        end

      end
    end
  end
end