class Provider
  attr_accessor :callback, :request_token, :access_token, :user_id, :user_name
  
  class << self
    def load(options)
      begin
        provider_class = options[:name].capitalize.constantize 
        provider           = provider_class.load(options)
        provider.user_id   = options[:user_id]
        provider.user_name = options[:user_name]
        return provider
      rescue
        return nil
      end
    end
    
    def find(name)
      begin
        provider_class = name.capitalize.constantize
        return provider_class.new
      rescue
        return nil
      end
    end
    
    def key; config['key'];  end
    def secret; config['secret']; end
    def url; config['url']; end
    
    def config
      @@config ||= {}
      @@config[self.name.downcase] ||= lambda do
        require 'yaml'
        filename = "#{Rails.root}/config/oauth.yml"
        file     = File.open(filename)
        yaml     = YAML.load(file)
        return yaml[self.name.downcase]
      end.call
    end
  end

  def dump
    {
      :request_token        => request_token.token, 
      :request_token_secret => request_token.secret,
      :access_token         => access_token.nil? ? nil : access_token.token,
      :access_token_secret  => access_token.nil? ? nil : access_token.secret,
      :user_id              => self.user_id,
      :name                 => self.class.name.downcase,
      :user_name            => self.user_name
    }
  end
  
  def request(http_method, path, headers = {})
    access_token.request(http_method, path, headers)
  end
    
  def get(path, headers = {})
    access_token.get(path, headers)
  end
  
  def post(path, body, headers = {})
    access_token.post(path, body, headers)
  end
    
  def delete(path, headers = {})
    request(:delete, path, headers)
  end
  
  def put(path, headers = {})
    request(:put, path, headers)
  end
  
  def name
    self.class.name.downcase
  end
end
