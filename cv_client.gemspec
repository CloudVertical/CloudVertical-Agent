# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "cv_client/version"

Gem::Specification.new do |gem|
  gem.name    = "cv_client"
  gem.version = CvClient::VERSION
  gem.platform    = Gem::Platform::RUBY
  gem.author      = "CvClient"
  gem.email       = "support@cv_client.com"
  gem.homepage    = "http://www.cloudvertical.com/"
  gem.summary     = "Gateway library and CLI to interact with CloudVertical API."
  gem.description = "Gateway library and CLI to interact with CloudVertical API."

  gem.files = %x{ git ls-files }.split("\n").select { |d| d =~ %r{^(README|bin/|data/|ext/|lib/|spec/|test|scripts/)} }
  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  
  gem.add_dependency "term-ansicolor", "~> 1.0.5"
  gem.add_dependency "rest-client",    "~> 1.6.1"
  gem.add_dependency "launchy",        ">= 0.3.2"
  gem.add_dependency "rubyzip"
  gem.add_dependency "amqp"
  gem.add_dependency "faraday"
  gem.add_dependency "yajl-ruby"
  gem.add_dependency "mechanize"
  gem.require_paths = ["lib"]  
end
