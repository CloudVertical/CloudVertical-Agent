module CvClient
  module Provider
    module Aws
      class Auth
    
        def echo_off
          system "stty -echo"
        end

        def echo_on
          system "stty echo"
        end

        def ask_for_credentials
          puts "Enter your credentials."

          api_key = ask("Cloud Vertical API key: ")
          user = ask("Email: ")
  
          email = ask("AWS email")
          password = running_on_windows? ? ask_for_password_on_windows : silent_ask("AWS password")
          access_key = ask("AWS Access Key ID")
          secret_key = ask("AWS Secret Access Key")  
  
          # api_key = 'api key' #Heroku::Client.auth(user, password, host)['api_key']

          self.credentials = [api_key, user, email, password, access_key, secret_key]
          p self.credentials
        end

        def ask_for_and_save_credentials
          begin
            @credentials = ask_for_credentials
            write_credentials
            check
          rescue ::RestClient::Unauthorized, ::RestClient::ResourceNotFound => e
            delete_credentials
            clear
            display "Authentication failed."
            exit 1
          rescue Exception => e
            delete_credentials
            raise e
          end
        end

        def ask_for_password_on_windows
          require "Win32API"
          char = nil
          password = ''

          while char = Win32API.new("crtdll", "_getch", [ ], "L").Call do
            break if char == 10 || char == 13 # received carriage return or newline
            if char == 127 || char == 8 # backspace and delete
              password.slice!(-1, 1)
            else
              # windows might throw a -1 at us so make sure to handle RangeError
              (password << char.chr) rescue RangeError
            end
          end
          puts
          return password
        end

        def silent_ask(msg)
          echo_off
          password = ask(msg)
          puts
          echo_on
          return password
        end

        def running_on_windows?
          false
        end

        def write_credentials()
          FileUtils.mkdir_p(File.dirname(credentials_file))
          f = File.open(credentials_file, 'w')
          f.puts self.credentials
          f.close
          set_credentials_permissions
        end
      end
    end
  end
end