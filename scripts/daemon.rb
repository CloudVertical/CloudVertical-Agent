Signal.trap('CHLD', 'IGNORE')

lib = File.expand_path(File.dirname(__FILE__) + '/../lib')
$LOAD_PATH.unshift(lib) if File.directory?(lib) && !$LOAD_PATH.include?(lib)
require File.join(lib, 'cv_client/provider/aws/billing')
require 'yaml'

CV_API_KEY = YAML::load(File.open("#{ENV["HOME"]}/.cvc/cv/credentials"))
AWS_CREDENTIALS = YAML::load(File.open("#{ENV["HOME"]}/.cvc/aws/credentials"))

loop do
	
	## pull billing data from AWS  
	billing = CvClient::Provider::Aws::Billing.new()
	billing.get_content
	billing.send
  
  sleep 60*60
end
