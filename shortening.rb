require 'rubygems'
require 'sinatra'
require 'haml'
require 'erb'
require 'json'
require 'mongo_mapper'

require File.join(File.dirname(__FILE__),'models' ,'link.rb')
require File.join(File.dirname(__FILE__),'models' ,'visitor.rb')
require File.join(File.dirname(__FILE__),'models','mapper.rb')

configure do
  #connect to mongo_db here
  #MongoMapper.connection = Mongo::Connection.new('hostname')
  MongoMapper.database = 'shortening-development'
end


get '/' do
  erb :index
end

get %r{/info/(\S+)} do |link_id|
  @link_id = link_id
  @shortened_link = Link.first(:url_key => link_id)
  
  if @shortened_link.nil?
    erb :not_found
  else
    @visitors = @shortened_link.visitors
    @long_link = @shortened_link.url
    @link = "http://#{request.host_with_port}/#{@link_id}"
    
    erb :info
  end
    
end

get '/stats' do
  @shortened_links = Link.all
  @link_count = @shortened_links.size
  
  erb :stats
end

get '/store' do
  
  unless (params[:url] =~ /^http:\/\//i)
    params[:url] = "http://#{params[:url]}"
  end
 
    link = Link.new
    link.url = params[:url]
    link.input_time = Time.now
    link.url_key = Mapper.map
    link.save
  
  redirect("/info/#{link.url_key}")
end

get %r{/(\S+)} do |link_id|
  @link_id = link_id
  #shortened_site = ""
  @current_link = Link.first(:url_key => link_id)
  
  unless @current_link.nil?
    shortened_site = @current_link.url
    visitor = Visitor.new(:ip_address => request.ip, :referer => request.referer, 
                          :time => Time.now, :user_agent => request.user_agent, :referrer => request.referrer)
    @current_link.visitors << visitor
    @current_link.save
    
    redirect shortened_site
  end
  erb :not_found
end