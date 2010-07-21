require File.join(File.dirname(__FILE__), 'spec_helper')

describe 'Shortening' do
  include Rack::Test::Methods
  
  def app
    @app ||= Sinatra::Application
  end
  
  before(:each) do
    MongoMapper.database.drop_collection('links')
  end
  
  describe "store" do
    it "should create a new link in the database" do
      get '/store?url=http://www.testurl.com'
      Link.all.count.should eql(1)
    end
  end
  
  
  context 'valid routes' do
    
    it 'should respond to /' do
      get '/'
      last_response.should be_ok
    end
    
    it 'should respond to /stats'do
      get '/stats'
      last_response.should be_ok
    end
    
    it 'should respond to /random' do
      get '/abcdef'
      last_response.should be_ok
    end
    
    it 'should respond to /info/random' do
      get '/info/abcdef'
      last_response.should be_ok
    end
    
  end
  
  context 'statistics page' do
    it "should contain the number of shortened strings stored on the server" do
      get '/stats'
      (last_response.body =~ /Your Shortening Server has (\d) links stored here :-\)/).should_not be_nil
    end
  end
  
  context 'info page' do
    before(:each) do
      Link.new(:url => "http://www.google.com", :input_time => Time.now, :url_key => "abcdef").save!
    end
    
    it "should contain the number of visitors to the shortened link" do
      get '/info/abcdef'
      (last_response.body =~ /we have seen (\d) to this shortened link/).should_not be_nil
    end
    
    it "should provide the actual link" do
      get '/info/abcdef'
      (last_response.body =~ /long link: http:\/\/www.google.com/).should_not be_nil
    end
    
    it "should route to the not found page if link can not be found" do
      get '/info/8f%347!as'
      (last_response.body =~ /Shortening - Link Not Found/).should_not be_nil
    end
    
  end
  
  context 'page redirection' do
    
    before(:each) do
      Link.new(:url => "http://www.google.com", :input_time => Time.now, :url_key => "abcdef").save!
    end
        
    it "should redirect the shortened link to is respective site" do
      get '/abcdef'
      follow_redirect!
      
      (last_request.url == "http://www.google.com/").should equal(true)
    end
    
    
  end
  
end