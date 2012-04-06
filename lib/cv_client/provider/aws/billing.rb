require 'base64'
require 'json'
module CvClient
  module Provider
    module Aws
      class Billing < CvClient::Provider::Aws::Base
        
        AWS_BILLING_END_POINT = "https://aws-portal.amazon.com/gp/aws/developer/account/index.html?ie=UTF8&action=activity-summary"
        VENDOR = "aws"
        TYPE = "billing"
        PATH = "/v01/statements.json"
        
        
        def initialize()
          super
        end
        
        
        def fetch_data

          timestamp = Time.now.utc
          # 1 agent
          agent = init_agent()
          # 2 get billing page
          page = agent.page
          # 3 get account number
          account_ref = get_acccount_number(page)
          # historical data
          if new?
            fetch_and_send_previous_months(agent, page, account_ref)
          end
          # 4 check if consolidatd
          if consolidated_billling?(page)
            # 5 if consolidated than fetch consolidated data and add it to @data
            parent_account_ref = account_ref
            @path = "/v01/statements/create_aws2.json"
            caccounts = consolidated_accounts(page)
            caccounts.each do |caccount|
              data = fetch_data_for_consolidated_account(agent, caccount[:account_number])
              @data << common_data.merge({:timestamp => timestamp,
                                          :account_ref => caccount[:account_number],
                                          :parent_account_ref => parent_account_ref,
                                          :data => data})
            end
          else
            # 6 else add data to @data
            @path = "/v01/statements/create_aws.json"
            @data << common_data.merge({:timestamp => timestamp,
                                        :account_ref => account_ref,
                                        :data => Base64.encode64(page.content)})
          end
          
        end
        
        def parse_data
        end
        
        def send(data = nil)
          @connection ||= CvClient::Core::Connection.new
          @connection.post({:data => data||@data}, @path||PATH)
        end
        
        private
        
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
          agent = init_agent()
          @content = agent.page.content
          return @content
        end
        
        def consolidated_billling?(page)
          page.search("div[id='payer_activity_table_tab_content']").any?
        end
        
        def get_acccount_number(page)
          r = page.search("span[class='txtxxsm']")
          txt = r.select{|rr| rr.children.text.match(/Account Number/)}[0].text
          account_number = txt.match(/([\d+-]+)/)[1].gsub("-","")
          return account_number
        end
        
        def consolidated_accounts(page)
          accounts = []
          spans = page.search("//span[substring(@id, 1, 27) = 'linked_account_toggle_name_']")
          spans.each do |span|
            accounts << {:account_number => span.attributes["id"].value.split('_')[-1], :account_name => span.children.text}
          end
          return accounts
        end
        
        def fetch_data_for_consolidated_account(agent, account_number)
          url = "https://aws-portal.amazon.com/gp/aws/developer/account/index.html?action=activity-summary&view-linked-bill-summary-button.x=yes&linkedAccountId=#{account_number}"
          page = agent.get(url)
          return page.content
          # data = JSON.parse page.body
          # return data
        end
        
        def common_data()
          return {:provider => PROVIDER, 
                  :label => @label,
                  :tags => parse_tags([])}
        end
        
        def new?
          @connection ||= CvClient::Core::Connection.new
          body = @connection.get('/v01/statements?limit=1&format=json').body
          JSON.parse(body).size == 0
        end
        
        def fetch_and_send_previous_months(agent, page, account_ref)
          data = []
          periods = page.search("select[name='statementTimePeriod']").children
          periods.each do |period|  
            if period.attributes['value'].value == ""
              next
            end
            url = AWS_BILLING_END_POINT
            period = period.attributes['value'].value.to_i
            
            date = Time.at(period).utc
            timestamp = date.end_of_month
            url2 = url + "&statementTimePeriod=#{period}"
            pg = agent.get(url2)
            data << common_data.merge({:data => Base64.encode64(pg.content), :timestamp => timestamp, :account_ref => account_ref})
          end
          @path = "/v01/statements/create_aws.json"
          send(data)
          return true
        end


      end
    end
  end
end