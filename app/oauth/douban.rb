class Douban < Provider
  class << self
    def load(data)
      access_token        = data[:access_token]
      access_token_secret = data[:access_token_secret]
    
      douban               = Douban.new(data[:request_token], data[:request_token_secret])
      douban.access_token  = OAuth::AccessToken.new(api_consumer, access_token, access_token_secret) if access_token
      douban
    end

    def auth_consumer
      @@auth_consumer ||= OAuth::Consumer.new(key, secret, {
          :signature_method   => "HMAC-SHA1",
          :site               => "http://www.douban.com",
          :scheme             => :header,
          :request_token_path => '/service/auth/request_token',
          :access_token_path  => '/service/auth/access_token',
          :authorize_path     => '/service/auth/authorize',
          :realm              => url
         })
    end
  
    def api_consumer
      @@api_consumer ||= OAuth::Consumer.new(key, secret,
        {
          :site             => "http://api.douban.com",
          :scheme           => :header,
          :signature_method => "HMAC-SHA1",
          :realm            => url
        })
    end
  end
  
  def initialize(request_token = nil, request_token_secret = nil)
    if request_token && request_token_secret
      self.request_token = OAuth::RequestToken.new(self.class.auth_consumer, request_token, request_token_secret)
    else
      self.request_token = self.class.auth_consumer.get_request_token()
    end
  end
  
  def authorize_url
    @authorize_url ||= request_token.authorize_url(:oauth_callback => self.callback)
  end
  
  def authorize(params)
    return unless self.access_token.nil?
    
    access_token = self.request_token.get_access_token
    self.access_token ||= OAuth::AccessToken.new(self.class.api_consumer, access_token.token, access_token.secret)
  end
  
  def authorized?
    return false if access_token.nil?
    response = self.get("/access_token/#{access_token.token}")
    response.code == '200'
  end
  
  def destroy
    destroy_access_key if !access_token.nil?
    request_token = access_token = nil
    @user = @authorize_url = nil
  end
  
  def user_id
    access_token.nil? ? nil : user.id
  end
  
  def events(city, page = 1, per_page = 10)
    response = get("/event/location/#{city}")
    response.body
  end
  
  def user_name
    access_token.nil? ? nil : user.title
  end
  
  def user_email; nil; end
  
  protected
  def user
    @user ||= lambda do
      response = get('/people/%40me?alt=json')
      DoubanResources::People.new(response.body)
    end.call
  end
  
  def destroy_access_key
    response = delete("/access_token/#{access_token.token}")
    response.code == '200'
  end
end
