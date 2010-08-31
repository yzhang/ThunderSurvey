require 'digest/sha1'
require 'net/http'
require 'uri'
    
class Form           
  include ActiveModel::Validations
  
  include MongoMapper::Document
  include Authentication
  
  key :title, String, :required => true
  key :description, String
  key :user_id, String
  key :edit_key, String
  key :email_notify, Boolean, :default => true 
  key :notify_url, String
  key :notify_type, String, :default => 'email'
  key :thanks_message, String, :default => ''
  key :publish_response, Boolean, :default => false 
  key :password, String, :default => ''
  key :end_at, Date, :default => nil
  key :logo,String
  
  key :rows_count, Integer, :default => 0
  key :maximum_rows, Integer
  key :height,Integer  
  key :recommanded,Boolean, :default => false
  
  key :created_at, Time, :default => Time.now
  key :updated_at, Time, :default => Time.now
  
  many :fields, :default => 0
  
  before_create :make_edit_key
  before_save   :update_timestamps  
    
  def id
    self._id.to_s
  end
  
  def user
    User.find(self.user_id)
  end
  
  def allow_insert?
    return true
  end
  
  def klass
    @klass ||= user_klass
  end
  
  def user_klass
    klass ||= Class.new
    klass.send(:include, MongoMapper::Document)
    klass.send(:include, ActiveModel::Naming)
    klass.set_collection_name(self.id.to_s)
    klass.key "created_at", Time
    klass.key 'order_id',Integer #保存订单信息
    klass.class_eval <<-METHOD
      def id
        self._id.to_s
      end

      def persisted?
        !new_record?
      end
    METHOD

    klass.instance_eval <<-NAME
      def name
        'Row'
      end
    NAME
    
    self.fields.each do |field|
      klass.key "f#{field.id}", String
      klass.validates_presence_of "f#{field.id}".to_sym if field.required
      klass.validates_format_of "f#{field.id}".to_sym, :with => Authentication.email_regex if field.intern == 'email'
      
      if field.input == 'check' || field.input == 'radio'
        klass.class_eval <<-METHOD
          alias_method :old_f#{field.id}=, :f#{field.id}=
          def f#{field.id}=(choices)
            if !choices.is_a?(Array)
              self.old_f#{field.id}= choices
              return
            end
            
            if choices.include?('_other')
              choices.delete('_other')
              other_options = choices.detect {|c| c.is_a?(Hash)}
              choices << other_options['other']
            end
            
            choices.reject! {|c| c.is_a?(Hash) || c.blank?}
            self.old_f#{field.id}= choices.join("\n")
          end
        METHOD
      end
    end
    klass
  end
  
  def deliver_notification(row)
    case self.notify_type
    when 'email'
      deliver_email_notification(row)
    end
  end
  
  def deliver_email_notification(row)
    Mailer.registrant_notification(self, row).deliver if self.user && self.user.email && self.email_notify
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
  
  def persisted?
    !new_record?
  end
  
  def find_field_by_uuid(uuid)
    self.fields.detect{|f| f.uuid == uuid}
  end
  
  def max_position
    self.fields.map {|f| f.position > 65530 ? 0 : f.position}.max
  end
  
  def rows_count
    @rows_count ||= self.klass.count
  end
  
  private
  def make_edit_key
    self.edit_key = self.class.make_token
  end
  
  def update_timestamps
    self.created_at ||= Time.now
    self.updated_at = Time.now
  end                 
  
  
  def self.sum(field)
    m = "function () {emit('sum', this.#{field.to_s})}"
    r = "function(k, vals) { var sum = 0; for(var i in vals){sum += vals[i];}; return sum;}"
    res = self.collection.map_reduce(m, r)
    return res.find().next_document['value'].to_i
  end    
end
