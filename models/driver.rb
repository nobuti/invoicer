class Driver < Sequel::Model
  plugin :validation_helpers
  plugin :json_serializer
  one_to_one :user

  # user, counter, year

end