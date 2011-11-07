#!/usr/bin/env ruby

require 'rubygems'
require 'daemons'

options = {
  :app_name   => "cvc-daemon",
  :dir_mode   => :script,
  :dir        => '/var/log',
  :multiple   => false,
  :ontop      => false,
  :mode       => :load,
  :backtrace  => true,
  :monitor    => true,
  :log_output => true
}

Daemons.run(File.join(File.dirname(__FILE__), 'daemon.rb'), options)


