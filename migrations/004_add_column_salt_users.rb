Sequel.migration do
  up do
    add_column :users, :password_salt, String
  end
  down do
    drop_column :users, :password_salt
  end
end