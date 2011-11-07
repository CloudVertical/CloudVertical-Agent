$:.unshift File.expand_path("../lib", __FILE__)
require "cv_client/version"

Gem::Specification.new do |gem|
  gem.name    = "cv_client"
  gem.version = CvClient::VERSION

  gem.author      = "CvClient"
  gem.email       = "support@cv_client.com"
  gem.homepage    = "http://cv_client.com/"
  gem.summary     = "Client library and CLI to deploy apps on CvClient."
  gem.description = "Client library and command-line tool to deploy and manage apps on CvClient."
  gem.executables = "cv_client"

  gem.files = %x{ git ls-files }.split("\n").select { |d| d =~ %r{^(README|bin/|data/|ext/|lib/|spec/|test/)} }

  gem.add_dependency "term-ansicolor", "~> 1.0.5"
  gem.add_dependency "rest-client",    "~> 1.6.1"
  gem.add_dependency "launchy",        ">= 0.3.2"
  gem.add_dependency "rubyzip"
end
