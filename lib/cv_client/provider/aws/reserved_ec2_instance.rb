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
          REGIONS.each do |region|
            ec2 = RightAws::Ec2.new(@access_key_id, @secret_access_key, :region => region)
            reserved_instances = ec2.describe_reserved_instances
            reserved_instances.each do |reserved_instance|
              @data << parse_data(reserved_instance)
            end
          end
          
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
                  :tags => parse_tags([])}
        end
                
        def send
          @connection ||= CvClient::Core::Connection.new
          @connection.post({:data => @data}, PATH)
        end

      end
    end
  end
end