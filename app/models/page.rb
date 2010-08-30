class Page
  include ActiveModel::Validations
  include ActiveModel::AttributeMethods
  include ActiveModel::Serialization
  include ActiveModel::Dirty
  
  include MongoMapper::Document
  
  key :title, String
  key :slug, String
  key :body, String
  
  def persisted?
    !new_record?
  end
end