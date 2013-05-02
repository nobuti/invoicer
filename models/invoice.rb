class Invoice < Sequel::Model
  plugin :validation_helpers
  plugin :json_serializer

  many_to_one :user

  # id_invoice, description, date, base, status, url

  def validate
    super
    validates_presence :description
    validates_numeric :base
  end

end