class Role
  include MongoMapper::EmbeddedDocument
  
  key :title, String, :required => true
end