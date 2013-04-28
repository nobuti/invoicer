Sequel.migration do
  up do
    create_table :projects do
      primary_key :id
      Integer :user_id, :null => true
      foreign_key [:user_id], :users, :name => 'fk_projects_user_id', :on_delete => :set_null
      String :name, :null=>false
      String :type
      DateTime :created_at
    end
  end
  down do
    alter_table :projects do
      drop_constraint 'fk_projects_user_id'
    end
    drop_table :projects
  end
end