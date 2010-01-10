class Form
  include MongoMapper::Document
  
  key :title, String, :required => true
  key :description, String
  
  many :fields
  many :rows
  
  def klass
    klass = Class.new
    klass.send(:include, MongoMapper::Document)
    klass.set_collection_name(self.id.to_s)
    
    self.fields.each do |field|
      klass.key "f#{field.id}", String
    end
    
    klass
  end
end
