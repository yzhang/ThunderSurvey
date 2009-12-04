# == Schema Information
# Schema version: 20090615182949
#
# Table name: users
#
#  id                        :integer         not null, primary key
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
#  balance                   :float
#

require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

  validates_presence_of     :name
  validates_length_of       :name, :maximum => 100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message

  before_create :make_activation_code 

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :email, :name, :password, :password_confirmation
  has_and_belongs_to_many :roles
  
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
    u = find :first, :conditions => ['email = ? and activated_at IS NOT NULL', email] # need to get the salt
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
