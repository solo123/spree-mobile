class User < ActiveRecord::Base

  has_many :orders
  has_and_belongs_to_many :roles
  belongs_to :ship_address, :foreign_key => "ship_address_id", :class_name => "Address"
  belongs_to :bill_address, :foreign_key => "bill_address_id", :class_name => "Address"
  has_one :profile # detail info - jimmy 2010.11.16

  before_save :check_admin
  before_validation :set_login

  acts_as_authentic do |c|
    c.transition_from_restful_authentication = true
    c.login_field = 'mobile'
    c.validate_login_field = true
    c.validate_email_field = false
    c.maintain_sessions = false
    #AuthLogic defaults
    #c.validate_email_field = true
    #c.validates_length_of_email_field_options = {:within => 6..100}
    #c.validates_format_of_email_field_options = {:with => email_regex, :message => I18n.t(‘error_messages.email_invalid’, :default => “should look like an email address.”)}
    #c.validate_password_field = true
    #c.validates_length_of_password_field_options = {:minimum => 4, :if => :require_password?}
    #for more defaults check the AuthLogic documentation
  end

  # Setup accessible (or protected) attributes for your model
  attr_accessible :mobile, :display_name, :email, :password, :password_confirmation, :remember_me

  alias_attribute :token, :persistence_token

  # has_role? simply needs to return true or false whether a user has a role or not.
  def has_role?(role_in_question)
    roles.any? { |role| role.name == role_in_question.to_s }
  end

  # Creates an anonymous user.  An anonymous user is basically an auto-generated +User+ account that is created for the customer
  # behind the scenes and its completely transparently to the customer.  All +Orders+ must have a +User+ so this is necessary
  # when adding to the "cart" (which is really an order) and before the customer has a chance to provide an email or to register.
  def self.anonymous!
    token = User.generate_token(:persistence_token)
    User.create(:email => "#{token}@example.net", :password => token, :password_confirmation => token)
  end

  def self.admin_created?
    Role.where(:name => "admin").includes(:users).count > 0
  end

  def deliver_password_reset_instructions!
    reset_perishable_token!
    UserMailer.password_reset_instructions(self).deliver
  end

  def stars
    r = self.roles
    if r.find_by_name('admin')
      6
    elsif r.find_by_name('R5')
      5
    elsif r.find_by_name('R4')
      4
    elsif r.find_by_name('R3')
      3
    elsif r.find_by_name('R2')
      2
    elsif r.find_by_name('R1')
      1
    else
      0
    end
  end

  private

  def check_admin
    return if self.class.admin_created?
    admin_role = Role.find_or_create_by_name "admin"
    self.roles << admin_role
  end

  def set_login
    # for now force login to be same as mobile//email, eventually we will make this configurable, etc.
    self.login ||= self.mobile if self.mobile
  end

  # Generate a friendly string randomically to be used as token.
  def self.friendly_token
    ActiveSupport::SecureRandom.base64(15).tr('+/=', '-_ ').strip.delete("\n")
  end

  # Generate a token by looping and ensuring does not already exist.
  def self.generate_token(column)
    loop do
      token = friendly_token
      break token unless find(:first, :conditions => { column => token })
    end
  end
  
  def self.find_by_email_or_mobile(login)
    User.find_by_mobile(login) || User.find_by_email(login)
  end

end
