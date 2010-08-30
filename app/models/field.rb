class Field
  include ActiveModel::Conversion
    
  include MongoMapper::EmbeddedDocument

  key :name, String, :required => true
  key :prompt, String
  key :required, Boolean, :required => true
  key :input, String, :required => true
  key :uuid,  String
  key :position, Integer  # 排序用
  key :intern, String     # 类保留字段型,如email字段,paypal字段等
  key :inputable,Boolean, :default => true
  key :include_other, Boolean, :default => false
  
  many :options
  
  TYPES = [['text', 'string'], ['paragraph_text', 'text'], 
            ['multi_choice', 'radio'], ['checkboxes', 'check'], 
            ['choose_from_a_list', 'drop']]
  
  def id
    self._id.to_s
  end
  
  def persisted?
    !new_record?
  end
  
  def multi?
    self.input == 'radio' || self.input == 'check'
  end
  
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
