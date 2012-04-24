require 'time'
module CvClient
  module Provider
    module Aws
      module CloudWatch
        class Ec2 < CloudWatch::Base
          MEASURE_NAMES = ["CPUUtilization", "NetworkIn", "NetworkOut"]
      
          def fetch_data
            now = Time.now.utc
            REGIONS.each do |region|
              ec2 = RightAws::Ec2.new(@access_key_id, @secret_access_key, :region => region)
              instances = ec2.describe_instances
              cw = RightAws::AcwInterface.new(@access_key_id, @secret_access_key, :endpoint => "http://monitoring.#{region}.amazonaws.com:443")
              instances.each do |instance|
                MEASURE_NAMES.each do |measure_name|
                  metrics = cw.get_metric_statistics({:namespace => "AWS/EC2", 
                                                      :statistics => ["Average", "Sum", "Maximum", "Minimum"], 
                                                      :measure_name => measure_name, 
                                                      :period => PERIOD, 
                                                      :start_time => (now - 3600).iso8601, 
                                                      :end_time => (now.iso8601),
                                                      :dimentions => {"InstanceId" => instance[:awsInstanceId]},
                                                      })
                  metrics[:datapoints].each do |metric|
                    @data << parse_data(metric, instance[:aws_instance_id], measure_name)
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