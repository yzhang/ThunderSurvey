class Field
  include MongoMapper::EmbeddedDocument

  key :name, String, :required => true
  key :prompt, String
  key :required, Boolean, :required => true
  key :input, String, :required => true
  key :uuid,  String
  key :position, Integer
  key :intern, String
  
  many :options
  
  def update_options(options)
    return true if options.nil? || !options.is_a?(Array)
    
    self.options.clear
    
    options.each do |value|
      option = Option.new(:value => value)
      self.options << option
      self.save
    end
  end
end
