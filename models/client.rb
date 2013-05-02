class Client
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :cif, String
  property :addres, Text

end