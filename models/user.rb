class User < Sequel::Model

  one_to_many :clients
  one_to_many :invoices

  plugin :validation_helpers
  plugin :json_serializer
  def validate
    super
    validates_presence :user
    validates_unique :user
  end

end