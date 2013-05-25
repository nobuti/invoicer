class Client
  include DataMapper::Resource

  belongs_to :user

  property :id, Serial
  property :name, String
  property :cif, String
  property :addres, Text

end