require 'right_aws'
module CvClient
  module Provider
    module Aws
      class Base
        
        AWS_BILLING_END_POINT = "https://aws-portal.amazon.com/gp/aws/developer/account/index.html?ie=UTF8&action=activity-summary"
        PATH = "/"
        PROVIDER = "Amazon"
        INSTANCE_TYPES = {"m1.small"   => {'cpu' => 1,   'ram' => 1.7},
                          'm1.medium'  => {'cpu' => 2,   'ram' => 3.75},
                          'm1.large'   => {'cpu' => 4,   'ram' => 7.5},
                          "m1.xlarge"  => {'cpu' => 8,   'ram' => 15},
                          "t1.micro"   => {'cpu' => 1,   'ram' => 0.613},
                          "m2.xlarge"  => {'cpu' => 6.5, 'ram' => 17.1},
                          "m2.2xlarge" => {'cpu' => 13,  'ram' => 34.2},
                          "m2.4xlarge" => {'cpu' => 26,  'ram' => 68.4},
                          "c1.medium"  => {'cpu' => 5,   'ram' => 1.7},
                          "c1.xlarge"  => {'cpu' => 20,  'ram' => 7},
                          "cc1.4xlarge"=> {'cpu' => 33.5,'ram' => 23},
                          "cc2.8xlarge"=> {'cpu' => 88,  'ram' => 60.5},
                          "cg1.4xlarge"=> {'cpu' => 33.5,'ram' => 22}
                          }
                          # , "ap-northeast-1", "us-west-2"
        REGIONS = ["eu-west-1", "us-east-1", "us-west-1", "ap-southeast-1", "sa-east-1"]
        
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
          @connection.post({:data => @data}, PATH)
        end

      end
    end
  end
end