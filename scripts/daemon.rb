Signal.trap('CHLD', 'IGNORE')

lib = File.expand_path(File.dirname(__FILE__) + '/../lib')
$LOAD_PATH.unshift(lib) if File.directory?(lib) && !$LOAD_PATH.include?(lib)
require File.join(lib, 'cv_client/provider/aws/billing')
require 'yaml'

credentials = YAML::load(File.open("#{ENV["HOME"]}/.cvc/aws/credentials"))

loop do
	
	## pull billing data from AWS  
	billing = CvClient::Provider::Aws::Billing.new(credentials[:email], credentials[:password])
	p billing.data
  
  sleep 60*60
end
