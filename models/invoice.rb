class Invoice

  include DataMapper::Resource

  belongs_to :user

  property :id, Serial
  property :description, Text
  property :date, Date
  property :base, Decimal
  property :status, Integer
  property :token, String
  property :identifier, String

  after :create do
    self.token = SecureRandom.hex
    self.status = 0
    self.date = Date.new
    current_year = self.date.strftime('%g')
    if !user.driver
      driver = Driver.create(:year => current_year, :counter => 0)
      driver.save
      self.identifier = "#01/#{current_year}"
    else
      if current_year != user.driver.year
        user.driver.update!(:year => current_year, :counter => 1)
        self.identifier = "#01/#{current_year}"
      else
        counter = user.driver.counter + 1
        user.driver.update!(:counter => counter)
        self.identifier = "##{(counter < 10 ? '0'+counter : counter)}/#{current_year}"
      end
    end
  end

  def self.years
    all(:fields => [:date]).map{ |item| item.date.year }.uniq
  end

  def generate_token
    self.update!(:token => SecureRandom.hex)
  end

end