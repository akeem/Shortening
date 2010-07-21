require 'rubygems'
require 'sinatra'
require 'rack/test'
require 'spec'
require 'spec/autorun'
require 'spec/interop/test'
require 'mongo_mapper'

require File.join(File.dirname(__FILE__),'..','models','mapper.rb')
require File.join(File.dirname(__FILE__),'..','models','link.rb')
require File.join(File.dirname(__FILE__), '..','shortening.rb')

set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

Spec::Runner.configure do |config|
  MongoMapper.database = 'shortening-test'
end