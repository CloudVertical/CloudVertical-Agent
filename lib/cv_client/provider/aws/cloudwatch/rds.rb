require 'time'
module CvClient
  module Provider
    module Aws
      module CloudWatch
        class Rds < CloudWatch::Base
          MEASURE_NAME = ['CPUUtilization', 'FreeableMemory', 'FreeStorageSpace']
      
          def fetch_data
            now = Time.now.utc
            REGIONS.each do |region|
              rds = RightAws::RdsInterface.new(@access_key_id, @secret_access_key, :region => region)
              instances = rds.describe_db_instances
              cw = RightAws::AcwInterface.new(@access_key_id, @secret_access_key, :region => region)
              instances.each do |instance|
                MEASURE_NAME.each do |measure|
                  metrics = cw.get_metric_statistics({:namespace => "AWS/RDS", 
                                                      :statistics => ["Average", "Sum", "Maximum", "Minimum"], 
                                                      :measure_name => measure, 
                                                      :period => PERIOD, 
                                                      :start_time => (now - 3600).iso8601, 
                                                      :end_time => (now.iso8601),
                                                      :dimentions => {"DBInstanceIdentifier" => instance[:aws_id]},
                                                      })
                  metrics[:datapoints].each do |metric|
                    @data << parse_data(metric, instance[:aws_id], measure)
                  end
                end
              end
            end
          end
          
        end        
      end
    end
  end
end