Signal.trap('CHLD', 'IGNORE')

lib = File.expand_path(File.dirname(__FILE__) + '/../lib')
$LOAD_PATH.unshift(lib) if File.directory?(lib) && !$LOAD_PATH.include?(lib)
require File.join(lib, 'cv_client/provider/aws/billing')
require File.join(lib, 'cv_client/provider/aws/base')
require File.join(lib, 'cv_client/provider/aws/ec2_instance')
require File.join(lib, 'cv_client/provider/aws/rds_instance')
require File.join(lib, 'cv_client/provider/aws/ec_instance')
require File.join(lib, 'cv_client/provider/aws/cloudwatch/base')
require File.join(lib, 'cv_client/provider/aws/cloudwatch/rds')
require File.join(lib, 'cv_client/provider/aws/cloudwatch/ec2')

require 'yaml'

CV_API_KEY = YAML::load(File.open("#{ENV["HOME"]}/.cvc/cv/credentials"))[:api_key]
AWS_CREDENTIALS = YAML::load(File.open("#{ENV["HOME"]}/.cvc/aws/credentials"))

loop do
	
	## pull billing data from AWS  
  billing = CvClient::Provider::Aws::Billing.new()
  billing.fetch_data
  billing.send
	
  # ec2_instance = CvClient::Provider::Aws::EC2Instance.new()
  # ec2_instance.fetch_data
  # ec2_instance.send
	
  # cw_instance = CvClient::Provider::Aws::CloudWatch.new()
  # cw_instance.fetch_data
  # cw_instance.send

  # rds_instance = CvClient::Provider::Aws::RdsInstance.new()
  # rds_instance.fetch_data
  # rds_instance.send
  
  # cw_rds = CvClient::Provider::Aws::CloudWatch::Rds.new()
  # cw_rds.fetch_data
  #   cw_rds.send  

  # ec_instance = CvClient::Provider::Aws::EcInstance.new()
  # ec_instance.fetch_data
  # ec_instance.send    
  
  sleep 60*60
end
