require 'digest/sha1'

class Form
  include MongoMapper::Document
  include Authentication
  
  key :title, String, :required => true
  key :description, String
  key :user_id, String
  key :edit_key, String
  
  many :fields
  
  before_create :make_edit_key
  
  def klass
    klass = Class.new
    klass.send(:include, MongoMapper::Document)
    klass.set_collection_name(self.id.to_s)
    
    self.fields.each do |field|
      klass.key "f#{field.id}", String
      klass.validates_presence_of "f#{field.id}", :message => "#{field.name} can't be blank" if field.required
      
      if field.input == 'check'
        klass.class_eval <<-METHOD
          alias_method :old_f#{field.id}=, :f#{field.id}=
          def f#{field.id}=(choices)
            self.old_f#{field.id}= choices.is_a?(Array) ? choices.join(',') : choices
          end
        METHOD
      end
    end
    
    klass
  end
  
  def sort_fields(positions)
    return if positions.nil? || !positions.is_a?(Hash) || positions.empty?
    
    positions.each do |uuid, position|
      field = self.find_field_by_uuid(uuid)
      if field
        field.position = position 
        field.save
      end
    end
  end
  
  def find_field_by_uuid(uuid)
    self.fields.detect{|f| f.uuid == uuid}
  end
  
  private
  def make_edit_key
    self.edit_key = self.class.make_token
  end
end
