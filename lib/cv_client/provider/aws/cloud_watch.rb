require 'time'
module CvClient
  module Provider
    module Aws
      class CloudWatch < CvClient::Provider::Aws::Base
        
        PATH = "/v01/computes/0/usages.json"
        PERIOD = 600
        SOURCE = 'CloudWatch'
        MEASURE_NAME = "CPUUtilization"
        
        def initialize()
          super
        end
                
        def fetch_data
          now = Time.now.utc
          REGIONS.each do |region|
            ec2 = RightAws::Ec2.new(@access_key_id, @secret_access_key, :region => region)
            instances = ec2.describe_instances
            cw = RightAws::AcwInterface.new(@access_key_id, @secret_access_key, :region => region)
            instances.each do |instance|
              p instance
              metrics = cw.get_metric_statistics({:namespace => "AWS/EC2", 
                                                  :statistics => ["Average", "Sum", "Maximum", "Minimum"], 
                                                  :measure_name => MEASURE_NAME, 
                                                  :period => PERIOD, 
                                                  :start_time => (now - 3600).iso8601, 
                                                  :end_time => (now.iso8601),
                                                  :dimentions => {"InstanceId" => instance[:aws_instance_id]},
                                                  })
              p metrics
              metrics[:datapoints].each do |metric|
                @data << parse_data(metric, instance[:aws_instance_id])
              end
            end
          end
          p @data
        end
        
        def parse_data(metric, instance_id)
          return metric.merge({:tags => [], 
                             :usage_type => MEASURE_NAME, 
                             :source => SOURCE, 
                             :period => PERIOD, 
                             :reference_id => instance_id,
                             :sample => metric.delete(:samples),
                             :total => 100})
        end

        def send
          @connection = CvClient::Core::Connection.new
          @connection.post({:data => @data}, PATH)
        end

      end
    end
  end
end