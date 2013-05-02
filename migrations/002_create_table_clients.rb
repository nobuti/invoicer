Sequel.migration do
  up do
    create_table :clients do
      primary_key :id
      Integer :user_id, :null => true
      foreign_key [:user_id], :users, :name => 'fk_clients_user_id'
      String :name, :null=>false
      String :cif, :null=>false
      String :address
      DateTime :created_at
    end
  end
  down do
    alter_table :clients do
      drop_constraint 'fk_clients_user_id'
    end
    drop_table :clients
  end
end