class User < Sequel::Model
  plugin :validation_helpers
  plugin :json_serializer
  def validate
    super
    validates_presence :user
    validates_unique :user
  end

end