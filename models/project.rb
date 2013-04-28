class Project < Sequel::Model
  plugin :validation_helpers
  plugin :json_serializer
  one_to_one :user
  one_to_many :tasks  
  def validate
    super
    validates_presence :name
    validates_presence :type
  end

end