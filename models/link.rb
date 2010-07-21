require 'mongo_mapper'

class Link 
  include MongoMapper::Document
  
  key :url, String
  key :input_time , Time
  key :url_key, String
  key :referrer, String
  many :visitors
  
  validates_uniqueness_of :url_key
  validates_uniqueness_of :url
  

end