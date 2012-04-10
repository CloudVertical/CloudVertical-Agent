Signal.trap('CHLD', 'IGNORE')

lib = File.expand_path(File.dirname(__FILE__) + '/../lib')
$LOAD_PATH.unshift(lib) if File.directory?(lib) && !$LOAD_PATH.include?(lib)
require File.join(lib, 'cv_client/provider/aws/billing')
require File.join(lib, 'cv_client/provider/aws/base')
require File.join(lib, 'cv_client/provider/aws/ec2_instance')
require File.join(lib, 'cv_client/provider/aws/rds_instance')
require File.join(lib, 'cv_client/provider/aws/ec_instance')
require File.join(lib, 'cv_client/provider/aws/s3_bucket')
require File.join(lib, 'cv_client/provider/aws/load_balancer')
require File.join(lib, 'cv_client/provider/aws/cloudwatch/base')
require File.join(lib, 'cv_client/provider/aws/cloudwatch/rds')
require File.join(lib, 'cv_client/provider/aws/cloudwatch/ec2')
require File.join(lib, 'cv_client/provider/aws/cloudwatch/ec')
require File.join(lib, 'cv_client/provider/aws/cloudwatch/elb')

require 'yaml'

CV_API_KEY = YAML::load(File.open("#{ENV["HOME"]}/.cvc/cv/credentials"))[:api_key]
AWS_CREDENTIALS = YAML::load(File.open("#{ENV["HOME"]}/.cvc/aws/credentials"))

loop do
	
	## pull billing data from AWS  
  # billing = CvClient::Provider::Aws::Billing.new()
  # billing.get_content
  # billing.send
	
  # ec2_instance = CvClient::Provider::Aws::EC2Instance.new()
  # ec2_instance.fetch_data
  # ec2_instance.send
  # 
  # cw_ec2 = CvClient::Provider::Aws::CloudWatch::Ec2.new()
  # cw_ec2.fetch_data
  # cw_ec2.send
  # 
  # rds_instance = CvClient::Provider::Aws::RdsInstance.new()
  # rds_instance.fetch_data
  # rds_instance.send
  # 
  # cw_rds = CvClient::Provider::Aws::CloudWatch::Rds.new()
  # cw_rds.fetch_data
  # cw_rds.send  
  # 
  # ec_instance = CvClient::Provider::Aws::EcInstance.new()
  # ec_instance.fetch_data
  # ec_instance.send    
  # 
  # cw_ec = CvClient::Provider::Aws::CloudWatch::Ec.new()
  # cw_ec.fetch_data
  # cw_ec.send
  # 
  # s3_bucket = CvClient::Provider::Aws::S3Bucket.new()
  # s3_bucket.fetch_data
  # s3_bucket.send
  # 
  # load_balancer = CvClient::Provider::Aws::LoadBalancer.new()
  # load_balancer.fetch_data
  # load_balancer.send
  # 
  # cw_elb = CvClient::Provider::Aws::CloudWatch::Elb.new()
  # cw_elb.fetch_data
  # cw_elb.send
      
  sleep 60*60
end
