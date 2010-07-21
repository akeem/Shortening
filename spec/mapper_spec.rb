require File.join(File.dirname(__FILE__), 'spec_helper')

describe Mapper do
  describe '.map' do
    
    it "should provide a map method" do
      Mapper.should.respond_to?(:map)
    end
    
    it "should provide a randomly generated value" do
      Mapper.map.should_not be_nil
    end
  end

end