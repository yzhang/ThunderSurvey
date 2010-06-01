class Page
  include ActiveModel::Validations
  include ActiveModel::AttributeMethods
  include ActiveModel::Serialization
  include ActiveModel::Dirty
  
  include MongoMapper::Document
  
  key :title, String
  key :slug, String
  key :body, String
  
  validates :title, :presence => true
  validates :slug, :presence => true
  validates :body, :presence => true
  
  def persisted?
    false
  end
end