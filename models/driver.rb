class Driver
  include DataMapper::Resource

  belongs_to :user

  property :id, Serial
  property :counter, Integer
  property :year, String

end