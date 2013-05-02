class Invoice

  include DataMapper::Resource

  belongs_to :user

  property :id, Serial
  property :description, Text
  property :date, Date
  property :base, Decimal
  property :status, Integer
  property :token, String

  # id_invoice, description, date, base, status, url

  after :create do
    self.token = SecureRandom.hex
  end

  def generate_token
    self.update!(:token => SecureRandom.hex)
  end

end