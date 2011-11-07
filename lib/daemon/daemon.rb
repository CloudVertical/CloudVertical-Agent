Signal.trap('CHLD', 'IGNORE')


loop do
	
	config = {:email => "aws@digitalmines.com", :password => "dmaws1011"}
  billing = CvClient::Provider::Aws::Billing.new(config[:email], config[:password])
	p billing.data
  
  sleep 60*60
end
