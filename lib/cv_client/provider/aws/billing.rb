module CvClient
  module Provider
    module Aws
      class Billing
        
        AWS_BILLING_END_POINT = "https://aws-portal.amazon.com/gp/aws/developer/account/index.html?ie=UTF8&action=activity-summary"
        VENDOR = "aws"
        TYPE = "billing"
        
        def initialize(email, password)
          @email, @password = email, password
        end
        
        def init_agent(page = AWS_BILLING_END_POINT)
          agent = Mechanize.new
          agent.user_agent_alias = "Mac Safari"
          agent.get(page)
          form = agent.page.form("signIn")
          form.email = @email
          form.password = @password
          form.submit
          return agent
        end
        
        def get_content
          agent = self.init_agent()
          @content = agent.page.content
          return @content
        end
        
        def send
          @connection = CvClient::Core::Connection.new
          @connection.post({:data => {:vendor => VENDOR, :type => TYPE, :content => @content}})
        end

      end
    end
  end
end