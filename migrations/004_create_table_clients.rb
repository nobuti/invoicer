Sequel.migration do
  up do
    create_table :clients do
      primary_key :id
      String :name, :null=>false
      String :cif, :null=>false
      String :address
      DateTime :created_at
    end
  end
  down do
    drop_table :clients
  end
end