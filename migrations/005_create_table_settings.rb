Sequel.migration do
  up do
    create_table :settings do
      primary_key :id
      Integer :user_id, :null => true
      foreign_key [:user_id], :users, :name => 'fk_settings_user_id'
      String :name
      String :nif
      String :address
      Numeric :iva
      Numeric :irpf
      DateTime :created_at
    end
  end
  down do
    alter_table :settings do
      drop_constraint 'fk_settings_user_id'
    end
    drop_table :settings
  end
end