require File.join(File.dirname(__FILE__), 'spec_helper')

describe Link do
  
  before(:each) do
    MongoMapper.database.drop_collection('links')
  end
  
  it "should provide a save method" do
    Link.new.should respond_to(:save)
  end
  
  it "should raise and exception if the url_key is in the database" do
    Link.new(:url => "http://www.google.com", :input_time => Time.now, :url_key => "abcdef").save!
    lambda{Link.new(:url => "http://www.google.com", :input_time => Time.now, :url_key => "abcdef").save!}.should raise_error
  end
  
end


