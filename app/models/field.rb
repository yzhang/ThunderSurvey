class Field
  include MongoMapper::EmbeddedDocument

  key :name, String, :required => true
  key :prompt, String
  key :required, Boolean, :required => true
  key :input, String, :required => true
  
  many :options
end
