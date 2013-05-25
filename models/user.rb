class User
  include DataMapper::Resource

  has n, :clients
  has n, :invoices
  has 1, :profile
  has 1, :driver

  attr_accessor :password, :password_confirmation

  property :id, Serial
  property :email, String, :required => true, :unique => true, :format => :email_address
  property :password_hash, Text
  property :password_salt, Text
  property :token, String
  property :enabled, Boolean, :default  => false
  property :created_at, Date

  validates_presence_of :password
  validates_confirmation_of :password
  validates_length_of :password, :min => 6

  after :create do
    self.token = SecureRandom.hex
  end

  def generate_token
    self.update!(:token => SecureRandom.hex)
  end

end