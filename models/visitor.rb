class Visitor
  include MongoMapper::EmbeddedDocument
  
  key :ip_address, String
  key :referer,  String
  key :time, Time
  key :user_agent, String
  
end