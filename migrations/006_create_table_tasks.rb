Sequel.migration do
  up do
    create_table :tasks do
      primary_key :id
      Integer :project_id, :null => true
      foreign_key [:project_id], :projects, :name => 'fk_tasks_project_id', :on_delete => :set_null
      String :label
      DateTime :created_at
    end
  end
  down do
    alter_table :tasks do
      drop_constraint 'fk_tasks_project_id'
    end
    drop_table :tasks
  end
end