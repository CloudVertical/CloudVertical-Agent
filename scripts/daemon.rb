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
require File.join(lib, 'cv_client/provider/aws/block_device')
require File.join(lib, 'cv_client/provider/aws/snapshot')
require File.join(lib, 'cv_client/provider/aws/cloudwatch/base')
require File.join(lib, 'cv_client/provider/aws/cloudwatch/rds')
require File.join(lib, 'cv_client/provider/aws/cloudwatch/ec2')
require File.join(lib, 'cv_client/provider/aws/cloudwatch/ec')
require File.join(lib, 'cv_client/provider/aws/cloudwatch/elb')
require File.join(lib, 'cv_client/provider/aws/cloudwatch/ebs')

require 'yaml'

CV_API_KEY = YAML::load(File.open("#{ENV["HOME"]}/.cvc/cv/credentials"))[:api_key]
AWS_CREDENTIALS = YAML::load(File.open("#{ENV["HOME"]}/.cvc/aws/credentials"))

loop do
	
	cloudwatch_components = [
    CvClient::Provider::Aws::CloudWatch::Ec2,
    CvClient::Provider::Aws::CloudWatch::Rds,
    CvClient::Provider::Aws::CloudWatch::Ec,
    CvClient::Provider::Aws::CloudWatch::Elb,
    CvClient::Provider::Aws::CloudWatch::Ebs
	  ]
	  
	components = [
    CvClient::Provider::Aws::Billing,
    CvClient::Provider::Aws::EC2Instance,
    CvClient::Provider::Aws::RdsInstance,
    CvClient::Provider::Aws::EcInstance,
	  CvClient::Provider::Aws::ReservedEC2Instance,
    CvClient::Provider::Aws::S3Bucket,
    CvClient::Provider::Aws::LoadBalancer,
    CvClient::Provider::Aws::BlockDevice,
    CvClient::Provider::Aws::Snapshot
	  ]

  cloudwatch_components.each do |cw|
    obj = cw.new()
    obj.fetch_data
    obj.send
  end

  components.each do |c|
    obj = c.new()
    obj.fetch_data
    obj.send
  end

  sleep 60*60
end
