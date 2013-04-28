Sequel.migration do
  up do
    create_table :drivers do
      primary_key :id
      Integer :user_id, :null => true
      foreign_key [:user_id], :users, :name => 'fk_drivers_user_id', :on_delete => :set_null
      String :year
      Numeric :invoice
    end
  end
  down do
    alter_table :drivers do
      drop_constraint 'fk_drivers_user_id'
    end
    drop_table :drivers
  end
end