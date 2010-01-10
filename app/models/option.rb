class Option
  include MongoMapper::EmbeddedDocument
  
  key :value, String, :required => true
end