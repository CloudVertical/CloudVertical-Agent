require 'right_aws'
module CvClient
  module Provider
    module Aws
      class Base
        
        AWS_BILLING_END_POINT = "https://aws-portal.amazon.com/gp/aws/developer/account/index.html?ie=UTF8&action=activity-summary"
        PATH = "/"
        PROVIDER = "Amazon"
        MAP_INSTANCE_TYPES = {'db.m1.small' => 'm1.small', 'cache.m1.small' => 'm1.small',
                     'db.m1.large' => 'm1.large', 'cache.m1.large' => 'm1.large',   
                     'db.m1.xlarge' => 'm1.xlarge', 'cache.m1.xlarge' => 'm1.xlarge',  
                     'db.m2.xlarge' => 'm2.xlarge', 'cache.m2.xlarge' => 'm2.xlarge',  
                     'db.m2.2xlarge' => 'm2.2xlarge', 'cache.m2.2xlarge' => 'm2.2xlarge', 
                     'db.m2.4xlarge' => 'm2.4xlarge', 'cache.m2.4xlarge' => 'm2.4xlarge', 
                     'cache.c1.xlarge' => 'c1.xlarge'
                    }      
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
                          
        REGIONS = ["eu-west-1", "us-east-1", "ap-northeast-1", "us-west-2", "us-west-1", "ap-southeast-1", "sa-east-1"]
        
        
        def initialize(credential = AWS_CREDENTIALS.merge(:auth_token => CV_API_KEY))
          @email, @password = credential[:email], credential[:password]
          @label = credential[:label]
          @access_key_id, @secret_access_key = credential[:access_key_id], credential[:secret_access_key]
          @auth_token = credential[:auth_token]
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
          @connection.post({:data => @data, :auth_token => auth_token}, PATH)
        end
        
        def connection
          @connection ||= CvClient::Core::Connection.new
          return @connection
        end

      end
    end
  end
end