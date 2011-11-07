Signal.trap('CHLD', 'IGNORE')

lib = File.expand_path(File.dirname(__FILE__) + '/../lib')
$LOAD_PATH.unshift(lib) if File.directory?(lib) && !$LOAD_PATH.include?(lib)
require File.join(lib, 'cv_client/provider/aws/billing')

loop do
	
	config = {:email => "aws@digitalmines.com", :password => "dmaws1011"}
  billing = CvClient::Provider::Aws::Billing.new(config[:email], config[:password])
	p billing.data
  
  sleep 60*60
end
