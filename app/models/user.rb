class User < ActiveRecord::Base
  include Sluggable

  has_many :posts
  has_many :comments
  has_many :votes

  has_secure_password validations: false

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, on: :create, length: {minimum: 5}

  sluggable_column :username

  def two_factor_auth?
    !self.phone.blank?
  end

  def generate_pin!
    self.update_column(:pin, rand(10 ** 6)) # random 6 digit #
  end

  def remove_pin!
    self.update_column(:pin, :nil)
  end

  def send_pin_to_twilio
    account_sid = 'AC9bbf5c9e5b50baa997754c69269e8dd3' 
    auth_token = 'a7f29bca3324651203474912f1b5fa9d'

    client = Twilio::REST::Client.new account_sid, auth_token 
    binding.pry
    msg = "Hi, please input the pint to continue login: #{self.pin}"
    number = self.phone
    client.account.messages.create({
    :from => '+15186564224', 
    :to => number, 
    :body => msg,  
    })
  end

  def admin?
    self.role == 'admin'
  end

  def moderator?
    self.role == 'moderator?'
  end
end