require 'time'
module CvClient
  module Provider
    module Aws
      module CloudWatch
        class Ec2 < CloudWatch::Base
          MEASURE_NAME = "CPUUtilization"
      
          def fetch_data
            now = Time.now.utc
            REGIONS.each do |region|
              ec2 = RightAws::Ec2.new(@access_key_id, @secret_access_key, :region => region)
              instances = ec2.describe_instances
              cw = RightAws::AcwInterface.new(@access_key_id, @secret_access_key, :region => region)
              instances.each do |instance|
                metrics = cw.get_metric_statistics({:namespace => "AWS/EC2", 
                                                    :statistics => ["Average", "Sum", "Maximum", "Minimum"], 
                                                    :measure_name => MEASURE_NAME, 
                                                    :period => PERIOD, 
                                                    :start_time => (now - 3600).iso8601, 
                                                    :end_time => (now.iso8601),
                                                    :dimentions => {"InstanceId" => instance[:awsInstanceId]},
                                                    })
                metrics[:datapoints].each do |metric|
#                  tags = instance[:tags].values.insert(0, instance[:aws_instance_type])
#                  @data << parse_data(metric, instance[:aws_instance_id], tags, MEASURE_NAME)
                  @data << parse_data(metric, instance[:aws_instance_id], MEASURE_NAME)                  
                end
              end
            end
            p @data
          end
          
        end
      end
    end
  end
end