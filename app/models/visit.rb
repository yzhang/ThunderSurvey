class Visit
  include ActiveModel::Conversion
    
  include MongoMapper::Document

  key :ip, String
  key :referrer, String
  key :host, String
  key :city, String
  key :created_at, Time
  key :form_id, String
end