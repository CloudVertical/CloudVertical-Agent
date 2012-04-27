module CvClient
  module Provider
    module Aws
      module CloudWatch
        class Base < CvClient::Provider::Aws::Base
      
          PATH = "/v01/computes/0/usages.json"
          PERIOD = 600
          SOURCE = 'CloudWatch'

          # def parse_data(metric, instance_id, tags, measure_name)
          # return metric.merge({:tags => parse_tags(tags), 
          def parse_data(metric, instance_id, measure_name)
            return metric.merge({:tags => [],             
                               :usage_type => measure_name, 
                               :source => SOURCE, 
                               :period => PERIOD, 
                               :reference_id => instance_id,
                               :sample => metric.delete(:samples),
                               :total => 100})
          end

          def fetch_data
          end

          def send
            connection.post({:data => @data, :auth_token => @auth_token}, PATH)
          end
          
        end 
      end
    end
  end
end