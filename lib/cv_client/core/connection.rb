require 'faraday'
require 'yajl'
require 'mechanize'

module CvClient
  module Core
    class Connection
      API_URL = 'http://api.cv.local/'
      
      def initialize(url = API_URL)
        @faraday = Faraday.new(:url => url) do |builder|
          builder.use Faraday::Request::UrlEncoded  
          builder.use Faraday::Request::JSON        
          builder.use Faraday::Response::Logger     
          builder.use Faraday::Adapter::NetHttp     
        end
      end
      
      def post(data, path = '/api/v1/push')
        @faraday.post do |req|
          req.url path, :auth_token => CV_API_KEY
          req.headers['Content-Type'] = 'application/json'
          req.body = data
        end
      end
      
    end
  end
end