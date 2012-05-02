require 'time'
module CvClient
  module Provider
    module Aws
      module CloudWatch
        class Elb < CloudWatch::Base
          MEASURE_NAME = ['Latency', 'RequestCount']
    
          def fetch_data
            now = Time.now.utc
            REGIONS.each do |region|
              begin
                elb = RightAws::ElbInterface.new(@access_key_id, @secret_access_key, :region => region)            
                balancers = elb.describe_load_balancers
                cw = RightAws::AcwInterface.new(@access_key_id, @secret_access_key, :region => region)
                balancers.each do |balancer|
                  MEASURE_NAME.each do |measure|
                    metrics = cw.get_metric_statistics({:namespace => 'AWS/ELB',
                                                        :statistics => ['Average', 'Maximum', 'Minimum', 'Sum'],
                                                        :measure_name => measure,
                                                        :period => PERIOD,
                                                        :start_time => (now - 3600).iso8601, 
                                                        :end_time => (now.iso8601),
                                                        :dimentions => {'LoadBalancerName' => balancer[:load_balancer_name]},
                                                        })
                    metrics[:datapoints].each do |metric|
                      @data << parse_data(metric, balancer[:load_balancer_name], measure)                    
                    end
                  end
                end
              rescue RightAws::AwsError => e
                p "CV_CLIENT ERROR: #{e}"            
              end              
            end
          end
          
        end
      end          
    end
  end
end
