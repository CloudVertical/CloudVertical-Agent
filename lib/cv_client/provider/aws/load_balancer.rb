module CvClient
  module Provider
    module Aws
      class LoadBalancer < CvClient::Provider::Aws::Base
        
        RESOURCE_TYPE = 'load_balancer'
        PATH = "/v01/networks.json"
           
        def fetch_data
          data = {:provider => PROVIDER, :network_type => RESOURCE_TYPE}
          REGIONS.each do |region|
            data.merge!(:location => region)
            elb = RightAws::ElbInterface.new(@access_key_id, @secret_access_key, :endpoint => "http://elasticloadbalancing.#{region}.amazonaws.com:443")
            balancers = elb.describe_load_balancers
            balancers.each do |balancer|
              @data << parse_data(balancer).merge(data)
            end
          end
        rescue RightAws::AwsError => e
          p "CV_CLIENT ERROR: #{e}"          
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