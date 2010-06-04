class Google < Provider
  class << self
    def load(data)
      access_token        = data[:access_token]
      access_token_secret = data[:access_token_secret]
    
      google               = Google.new(data[:request_token], data[:request_token_secret])
      google.access_token  = OAuth::AccessToken.new(auth_consumer, access_token, access_token_secret) if access_token
      google
    end

    def auth_consumer
      @@auth_consumer ||= OAuth::Consumer.new(key, secret, {
          :signature_method   => "HMAC-SHA1",
          :site               => "https://www.google.com",
          :scheme             => :header,
          :request_token_path => '/accounts/OAuthGetRequestToken',
          :access_token_path  => '/accounts/OAuthGetAccessToken',
          :authorize_path     => '/accounts/OAuthAuthorizeToken',
         })
    end
  end
  
  def initialize(request_token = nil, request_token_secret = nil)
    if request_token && request_token_secret
      self.request_token = OAuth::RequestToken.new(self.class.auth_consumer, request_token, request_token_secret)
    end
  end
  
  def authorize_url
    self.request_token = self.class.auth_consumer.get_request_token({:oauth_callback => self.callback},{
              :scope => "https://www.google.com/calendar/feeds"}) if self.request_token.nil?
    @authorize_url ||= request_token.authorize_url
  end
  
  def authorize(params)
    return unless self.access_token.nil?
    
    self.access_token ||= self.request_token.get_access_token({}, {:oauth_verifier => params[:oauth_verifier]})
  end
  
  def user_id
    @user_id ||= access_token.nil? ? nil : user.css('email').first.text
  end

  def user_name
    @user_name ||= access_token.nil? ? nil : user.css('name').first.text
  end
  
  def user_email
    user_name
  end
  
  def authorized?
  end
  
  def destroy
    @user = @user_id = @user_name = nil
  end
  
  protected
  def user
    @user ||= lambda do 
      response = get('/calendar/feeds/default/settings')
      while response.code == '302' && response['location']
        response = get(response['location'])
      end
      Nokogiri::XML(response.body)
    end.call
  end
end
