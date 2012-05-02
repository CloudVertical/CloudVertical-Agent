module CvClient
  module Provider
    module Aws
      class Snapshot < CvClient::Provider::Aws::Base
        
        RESOURCE_TYPE = 'snapshot'
        STATUSES = {'pending' => 'pending', 'completed' => 'completed', 'error' => 'error'}
        PATH = "/v01/generics.json"
            
        def fetch_data
          data = {:provider => PROVIDER, :generic_type => RESOURCE_TYPE}
          REGIONS.each do |region|
            begin
              data.merge!(:location => region)
              ec2 = RightAws::Ec2.new(@access_key_id, @secret_access_key, :region => region)
              snapshots = ec2.describe_snapshots(:Owner => 'self')
              snapshots.each do |snapshot|
                @data << parse_data(snapshot).merge(data)
              end
            rescue RightAws::AwsError => e
              p "CV_CLIENT ERROR: #{e}"
            end
          end
        end
        
        def parse_data(snapshot)
          return {'credential_label' => @label,
                  'label' => snapshot[:tags] ? snapshot[:tags]['Name'] : '',            
                  'reference_id' => snapshot[:aws_id], 
                  'status' => STATUSES[snapshot[:aws_status]],
                  'tags' => parse_tags(snapshot[:tags].values)}
        end

        def send
          connection.post({:data => @data, :auth_token => @auth_token}, PATH)
        end

      end
    end
  end
end