class Feedback
  include ActiveModel::Validations
  include ActiveModel::AttributeMethods
  include ActiveModel::Serialization
  include ActiveModel::Dirty
  
  include MongoMapper::Document
  
  key :email, String
  key :name, String
  key :content, String
  key :created_at, Time
  key :updated_at, Time
  
  validates_presence_of :email, :message => '不能为空'
  validates_presence_of :name, :message => '不能为空'  
  validates_presence_of :content, :message => '不能为空'  
  
  def persisted?
    false
  end
end