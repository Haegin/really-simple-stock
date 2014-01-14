require 'rubygems' unless defined? Gem
require 'bundler/setup'

require 'minitest/autorun'
require 'minitest/ansi'

require 'really_simple_stock'

def today
  Date.today
end

def yesterday
  Date.today.prev_day
end

MiniTest::ANSI.use!
