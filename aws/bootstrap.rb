require 'rubygems'
require 'aws-sdk'
require 'yaml'
require 'pp'
require 'json'
require File.expand_path('../../libs/utils.rb', __FILE__)

$config_file_path = ARGV.shift
$config           = load_yaml($config_file_path)
$logger           = Logger.new("/tmp/#{File.basename($0)}.log")

$logger.datetime_format = '%Y-%m-%dT%H:%M:%S'
$logger.formatter = proc{|severity, datetime, progname, message|
  "[#{severity}] #{datetime}: #{message}\n"
}



