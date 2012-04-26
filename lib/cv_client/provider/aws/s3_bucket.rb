module CvClient
  module Provider
    module Aws
      class S3Bucket < CvClient::Provider::Aws::Base
        
        RESOURCE_TYPE = 's3_bucket'
        PATH = "/v01/storage.json"
        
        def initialize()
          super
        end
                
        def fetch_data
          data = {:provider => PROVIDER, :storage_type => RESOURCE_TYPE}
          s3 = RightAws::S3Interface.new(@access_key_id, @secret_access_key)
          buckets = s3.list_all_my_buckets
          p buckets
          buckets.each do |bucket|
            location = s3.bucket_location(bucket[:name])
            location = 'US Standard' if location.empty?
            capacity = calculate_size(s3, bucket)
            data.merge!(:location => location, :capacity => capacity)
            @data << parse_data(bucket).merge(data)
          end
        rescue RightAws::AwsError => e
          p "CV_CLIENT ERROR: #{e}"          
        end
        
        def parse_data(bucket)
          return {'credential_label' => @label,
                  'reference_id' => bucket[:name],
                  'status' => 'running',
                  'tags' => parse_tags([])}
    
        end

        def calculate_size(s3, bucket)
          items = nil
          s3.incrementally_list_bucket(bucket[:name]) do |result|
            items = result[:contents]
          end
          capacity = items.inject(0){|sum, item| sum + item[:size]}
          capacity/1024/1024
        end

        def send
          connection.post({:data => @data}, PATH) unless @data.empty?
        end

      end
    end
  end
end