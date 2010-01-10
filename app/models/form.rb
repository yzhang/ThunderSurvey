class Form
  include MongoMapper::Document
  
  key :title, String, :required => true
  key :description, String
  
  many :fields
end
