class Field
  include MongoMapper::EmbeddedDocument

  key :name, String, :required => true
  key :prompt, String
  key :required, Boolean, :required => true
  key :input, String, :required => true
  
  many :options
  
  def update_options(options)
    return true if options.nil? || !options.is_a?(Hash)
    
    options.each do |id, value|
      option = self.options.find(id)
      option.update_attributes(:value => value) if option
    end
    
    return true
  end
end
