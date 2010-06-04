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
  
  validates_presence_of :email, :presence => true,:message => '不能为空'
  validates_presence_of :name, :presence => true,:message => '不能为空'  
  validates_presence_of :content, :presence => true,:message => '不能为空'  
  
  def persisted?
    false
  end
end