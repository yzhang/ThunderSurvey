# == Schema Information
#
# Table name: users
#
#  id                        :integer         not null, primary key
#  login                     :string(40)
#  name                      :string(100)     default("")
#  email                     :string(100)
#  crypted_password          :string(40)
#  salt                      :string(40)
#  created_at                :datetime
#  updated_at                :datetime
#  remember_token            :string(40)
#  remember_token_expires_at :datetime
#  activation_code           :string(40)
#  activated_at              :datetime
#

require 'digest/sha1'

class User
  include MongoMapper::Document
  include Paperclip
  
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

  key :name, String, :required => true, :length => {:maximum => 100}
  key :email, String, :required => true, :unique => true, :length => {:minimum => 6}, :format => Authentication.email_regex
  key :crypted_password, String
  key :salt, String
  key :updated_at, Time
  key :created_at, Time
  key :remember_token, String
  key :remember_token_expires_at, Time
  key :type, String
  key :contact, String
  key :phone_number, String
  key :description, String, :length => {:maximum => 1024}
  key :logo_file_name, String
  key :website, String
  key :activation_code, String
  key :activated_at, Time
  
  has_attached_file :logo, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  
  before_create :make_activation_code 
  
  # Activates the user in the database.
  def activate!
    @activated = true
    self.activated_at = Time.zone.now
    self.activation_code = nil
    save(false)
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end

  def active?
    # the existence of an activation code means they have not activated yet
    activation_code.nil?
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(email, password)
    return nil if email.blank? || password.blank?
    u = find(:first, :conditions => {:email => email, :activation_code => nil}) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  protected
    def make_activation_code
        self.activation_code = self.class.make_token
    end
end
