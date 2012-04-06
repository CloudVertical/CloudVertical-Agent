module CvClient
  module Provider
    module Aws
      class LoadBalancer < CvClient::Provider::Aws::Base
        
        RESOURCE_TYPE = 'load_balancer'
        PATH = "/v01/networks.json"
        
        def initialize()
          super
        end
                
        def fetch_data
          data = {:provider => PROVIDER, :network_type => RESOURCE_TYPE}
          REGIONS.each do |region|
            data.merge!(:location => region)
            elb = RightAws::ElbInterface.new(@access_key_id, @secret_access_key, :region => region)
            balancers = elb.describe_load_balancers
            balancers.each do |balancer|
              @data << parse_data(balancer).merge(data)
            end
          end
          p @data
        end
        
        def parse_data(balancer)
          return {'reference_id' => balancer[:load_balancer_name],
                  'status' => 'active',
                  'tags' => parse_tags([])}
    
        end

        def send
          @connection = CvClient::Core::Connection.new
          @connection.post({:data => @data}, PATH)
        end

      end
    end
  end
end