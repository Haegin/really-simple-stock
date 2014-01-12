require 'rubygems' unless defined? Gem
require 'bundler/setup'

require 'minitest/autorun'
require 'minitest/ansi'

def today
  Date.today
end

def yesterday
  Date.today.prev_day
end

MiniTest::ANSI.use!
