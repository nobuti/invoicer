class Setting < Sequel::Model
  plugin :validation_helpers
  plugin :json_serializer
  one_to_one :user

  # name, nif, address, iva, irpf

  def validate
    super
    validates_presence :name
    validates_presence :nif
    validates_presence :address
    validates_numeric :iva, :allow_nil=>false
    validates_numeric :irpf, :allow_nil=>false
  end

end