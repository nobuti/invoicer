Sequel.migration do
  up do
    create_table :users do
      primary_key :id
      String :user, :null=>false
      String :password_hash
      String :password_salt
      String :forgot_code
      Integer :state, :default => 0
      DateTime :created_at
    end
  end
  down do
    alter_table :users do
      drop_column :id, :cascade=>true
    end
    drop_table :users
  end
end