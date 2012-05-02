require 'time'
module CvClient
  module Provider
    module Aws
      module CloudWatch
        class Ebs < CloudWatch::Base
          MEASURE_NAME = ['VolumeReadBytes', 'VolumeWriteBytes', 'VolumeReadOps', 'VolumeWriteOps']
    
          def fetch_data
            now = Time.now.utc
            REGIONS.each do |region|
              begin
                ec2 = RightAws::Ec2.new(@access_key_id, @secret_access_key, :region => region)
                volumes = ec2.describe_volumes              
                cw = RightAws::AcwInterface.new(@access_key_id, @secret_access_key, :region => region)
                volumes.each do |volume|
                  MEASURE_NAME.each do |measure|
                    metrics = cw.get_metric_statistics({:namespace => 'AWS/EBS',
                                                        :statistics => ['Average', 'Maximum', 'Minimum', 'Sum'],
                                                        :measure_name => measure,
                                                        :period => PERIOD,
                                                        :start_time => (now - 3600).iso8601, 
                                                        :end_time => (now.iso8601),
                                                        :dimentions => {'VolumeId' => volume[:aws_id]},
                                                        })
                    metrics[:datapoints].each do |metric|
                      @data << parse_data(metric, volume[:aws_id], measure)                    
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