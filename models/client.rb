class Client < Sequel::Model
  plugin :validation_helpers
  plugin :json_serializer

  # name, cif, address

  def validate
    super
    validates_presence :name
    validates_presence :cif
    validates_presence :address
  end

end