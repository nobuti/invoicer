class Profile
  include DataMapper::Resource

  belongs_to :user

  # name, nif, address, iva, irpf

  property :id, Serial
  property :name, String
  property :nif, String
  property :addres, Text
  property :iva, Decimal
  property :irpf, Decimal

end