require 'right_aws'
module CvClient
  module Provider
    module Aws
      class Base
        
        AWS_BILLING_END_POINT = "https://aws-portal.amazon.com/gp/aws/developer/account/index.html?ie=UTF8&action=activity-summary"
        PATH = "/"
        PROVIDER = "Amazon"
        INSTANCE_TYPES = {'m1.medium' => {'cpu' => 2, 'ram' => 3.75},
                          'm1.large' => {'cpu' => 4, 'ram' => 7.5},
                          "m1.xlarge" => {'cpu' => 8, 'ram' => 15},
                          "m1.small" => {'cpu' => 1, 'ram' => 1.7}, 
                          "t1.micro" => {'cpu' => 1, 'ram' => 0.613}, 
                          "c1.medium" => {'cpu' => 5, 'ram' => 1.7}
                          }
        REGIONS = ["eu-west-1", "us-east-1", "ap-northeast-1", "us-west-1", "ap-southeast-1", "us-west-2", "sa-east-1"]
        
        def initialize()
          @email, @password = AWS_CREDENTIALS[:email], AWS_CREDENTIALS[:password]
          @label = AWS_CREDENTIALS[:label]
          @access_key_id, @secret_access_key = AWS_CREDENTIALS[:access_key],  AWS_CREDENTIALS[:secret_key]
          @data = []
        end
        
        
        def fetch_data
        end
        
        def parse_data
        end     
        
        def parse_tags(tags)
          return tags.push(@label).reject(&:empty?)
        end 
                
        def send
          @connection = CvClient::Core::Connection.new
          @connection.post({:data => [@data]}, PATH)
        end

      end
    end
  end
end