Signal.trap('CHLD', 'IGNORE')


loop do 
  agent = init_agent('aws@digitalmines.com', 'dmaws101' )
	p agent.page.content
  
  sleep 5
end
