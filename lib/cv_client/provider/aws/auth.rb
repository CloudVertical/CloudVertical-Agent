module CvClient
  module Provider
    module Aws
      class Auth < CvClient::Provider::Base::Auth
        
        def ask_for_credentials
          puts "Enter your Amazon Web Services credentials."

          email = ask("email")
          password = running_on_windows? ? ask_for_password_on_windows : silent_ask("password")
          access_key = ask("Access Key ID")
          secret_key = ask("Secret Access Key")

          self.credentials = {
            :email => email.to_s, 
            :password => password.to_s, 
            :access_key => access_key.to_s, 
            :secret_key => secret_key.to_s
          }
        end
      end
    end
  end
end