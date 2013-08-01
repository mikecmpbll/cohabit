require 'test_helper'
$LOAD_PATH << File.join(File.dirname(__FILE__), '..')
$LOAD_PATH << File.dirname(__FILE__)
Dir.glob('test/*_test.rb', &method(:require))
load_schema