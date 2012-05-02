module CvClient
  module Provider
    module Aws
      class LoadBalancer < CvClient::Provider::Aws::Base
        
        RESOURCE_TYPE = 'load_balancer'
        PATH = "/v01/networks.json"
           
        def fetch_data
          data = {:provider => PROVIDER, :network_type => RESOURCE_TYPE}
          REGIONS.each do |region|
            begin
              data.merge!(:location => region)
              elb = RightAws::ElbInterface.new(@access_key_id, @secret_access_key, :region => region)
              balancers = elb.describe_load_balancers
              balancers.each do |balancer|
                @data << parse_data(balancer).merge(data)
              end
            rescue RightAws::AwsError => e
              p "CV_CLIENT ERROR: #{e}"          
            end
          end
        end
        
        def parse_data(balancer)
          return {'credential_label' => @label,
                  'reference_id' => balancer[:load_balancer_name],
                  'status' => 'running',
                  'tags' => parse_tags([])}
    
        end

        def send
          connection.post({:data => @data, :auth_token => @auth_token}, PATH)
        end

      end
    end
  end
end