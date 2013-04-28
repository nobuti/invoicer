Sequel.migration do
  up do
    add_column :users, :forgot_code, String
    add_column :users, :state, Integer, :default => 0
  end
  down do
    drop_column :users, :forgot_code
    drop_column :users, :state
  end
end