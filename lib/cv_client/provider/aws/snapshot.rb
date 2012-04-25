module CvClient
  module Provider
    module Aws
      class Snapshot < CvClient::Provider::Aws::Base
        
        RESOURCE_TYPE = 'snapshot'
        INSTANCE_STATUSES = {'pending' => 'pending', 'completed' => 'completed', 'error' => 'error'}
        PATH = "/v01/generics.json"
        
        def initialize()
          super
        end
                
        def fetch_data
          data = {:provider => PROVIDER, :generic_type => RESOURCE_TYPE}
          REGIONS.each do |region|
            data.merge!(:location => region)
            ec2 = RightAws::Ec2.new(@access_key_id, @secret_access_key, :region => region)
            snapshots = ec2.describe_snapshots(:Owner => 'self')
            snapshots.each do |snapshot|
              @data << parse_data(snapshot).merge(data)
            end
          end
        end
        
        def parse_data(snapshot)
          return {'credential_label' => @label,
                  'reference_id' => snapshot[:aws_id], 
                  'status' => INSTANCE_STATUSES[snapshot[:aws_status]],
                  'tags' => parse_tags(snapshot[:tags].values)}
        end

        def send
          @connection = CvClient::Core::Connection.new
          @connection.post({:data => @data}, PATH)
        end

      end
    end
  end
end