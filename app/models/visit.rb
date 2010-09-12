class Visit
  include ActiveModel::Conversion
    
  include MongoMapper::Document

  key :ip, String
  key :referrer, String
  key :host, String
  key :city, String
  key :created_at, Time
  key :form_id, String
  
  def self.group_by_created_at(conds={})
    conds[:created_at] = {'$gt' => 1.month.ago.utc}
    keyf = 'function(doc) {return {"created_on" : String(doc.created_at).split(" ").slice(0,4).join(" ")};}'
    r = "function(obj, prev) {prev.count += 1}"
    res = Visit.collection.group(keyf, conds, {:count => 0}, r)
    res.sort {|m, n| Time.parse(m['created_on']) <=> Time.parse(n['created_on']) }
  end
  
  def self.group_by_host(conds={})
    conds[:created_at] = {'$gt' => 1.month.ago.utc}
    r = "function(obj, prev) {prev.count += 1}"
    res = Visit.collection.group(['host'], conds, {:count => 0}, r)
  end
  
  def self.group_by_city(conds={})
    conds[:created_at] = {'$gt' => 1.month.ago.utc}
    r = "function(obj, prev) {prev.count += 1}"
    res = Visit.collection.group(['city'], conds, {:count => 0}, r)
  end
end