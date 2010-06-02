class Email
  include ActiveModel::Validations
  include ActiveModel::AttributeMethods
  include ActiveModel::Serialization
  include ActiveModel::Dirty
  
  include MongoMapper::Document
  
  key :from, String
  key :to, String
  key :last_send_attempt, Integer, :default => 0
  key :mail, String
  key :created_on, Time
  
  def persisted?
    !new_record?
  end
  
  def self.find(matcher, options = {})
    self.all(:limit => 200)
  end
  
  def self.destroy_all(options)
    self.all(:conditions => {:last_send_attemp => 0}, :limit => 200).each do |m|
      m.destroy
    end
  end
end