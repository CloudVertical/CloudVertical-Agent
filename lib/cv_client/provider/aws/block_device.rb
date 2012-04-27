module CvClient
  module Provider
    module Aws
      class BlockDevice < CvClient::Provider::Aws::Base
        
        RESOURCE_TYPE = 'block_device'
        STATUSES = {'creating' => 'available', 'available' => 'available', 'in-use' => 'in-use', 'deleting' => 'deleted', 'deleted' => 'deleted', 'error' => 'error'}
        PATH = "/v01/storage.json"
          
        def fetch_data
          data = {:provider => PROVIDER, :storage_type => RESOURCE_TYPE}
          REGIONS.each do |region|
            data.merge!(:location => region)
            ec2 = RightAws::Ec2.new(@access_key_id, @secret_access_key, :region => region)
            volumes = ec2.describe_volumes
            volumes.each do |volume|
              @data << parse_data(volume).merge(data)
            end
          end
        rescue RightAws::AwsError => e
          p "CV_CLIENT ERROR: #{e}"          
        end
        
        def parse_data(volume)
          return {'credential_label' => @label,
                  'reference_id' => volume[:aws_id], 
                  'capacity' => volume[:aws_size].to_i * 1024,
                  'status' => STATUSES[volume[:aws_status]],
                  'tags' => parse_tags(volume[:tags].values)}
        end

        def send
          connection.post({:data => @data, :auth_token => @auth_token}, PATH)
        end

      end
    end
  end
end