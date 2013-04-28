class Task < Sequel::Model
  plugin :validation_helpers
  plugin :json_serializer
  many_to_one :project
  def validate
    super
    validates_presence :label
    validates_presence :project_id
  end

end