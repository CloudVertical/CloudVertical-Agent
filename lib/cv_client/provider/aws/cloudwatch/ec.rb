require 'time'
module CvClient
  module Provider
    module Aws
      module CloudWatch
        class Ec < CloudWatch::Base
          MEASURE_NAME = ['CPUUtilization', 'FreeableMemory']
      
          def fetch_data
            now = Time.now.utc
            datapoints = {}
            REGIONS.each do |region|
              begin
                ec = RightAws::EcInterface.new(@access_key_id, @secret_access_key, :server => "elasticache.#{region}.amazonaws.com")
                instances = ec.describe_cache_clusters
                cw = RightAws::AcwInterface.new(@access_key_id, @secret_access_key, :region => region)
                instances.each do |instance|                
                  cache_nodes = instance[:cache_nodes]
                  MEASURE_NAME.each do |measure|
                    datapoints[measure] = []                 
                    cache_nodes.each do |cache_node|
                      metrics = cw.get_metric_statistics({:namespace => "AWS/ElastiCache", 
                                                          :statistics => ["Average", "Sum", "Maximum", "Minimum"], 
                                                          :measure_name => measure, 
                                                          :period => PERIOD, 
                                                          :start_time => (now - 3600).iso8601, 
                                                          :end_time => (now.iso8601),
                                                          :dimentions => {"CacheClusterId" => instance[:aws_id], "CacheNodeId" => cache_node[:cache_node_id]},
                                                          })
                      datapoints[measure] << metrics[:datapoints]                                                        
                    end
                    datapoints[measure].flatten!
                    timestamps = []
                    merged_metrics = []
                    datapoints[measure].each do |datapoint|
                      timestamps << datapoint[:timestamp]
                    end
                    timestamps.each do |timestamp|
                      minimum = []; maximum = []; sum = []; average = []                    
                      selected_metrics = datapoints[measure].flatten.select{|d| d[:timestamp] == timestamp}
                      selected_metrics.each do |metric|
                        minimum << metric[:minimum]
                        maximum << metric[:maximum]
                        sum << metric[:sum]
                        average << metric[:average]                                                                  
                      end
                      merged_metrics << {:timestamp=>timestamp,
                                         :unit=>selected_metrics.last[:unit],
                                         :minimum=>(minimum.min),
                                         :maximum=>(maximum.max),
                                         :sum=>(sum.inject(:+)),
                                         :samples=>selected_metrics.last[:samples],
                                         :average=>(average.inject(:+)/average.size)
                                         }
                    end                  
                    merged_metrics.each do |metric|
                      @data << parse_data(metric, instance[:aws_id], measure)
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