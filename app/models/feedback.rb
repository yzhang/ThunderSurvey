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
  
  validates :email, :presence => true
  validates :name, :presence => true
  validates :content, :presence => true
  
  def persisted?
    false
  end
end