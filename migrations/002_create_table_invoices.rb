Sequel.migration do
  up do
    create_table :invoices do
      primary_key :id
      Integer :user_id, :null => true
      foreign_key [:user_id], :users, :name => 'fk_invoices_user_id', :on_delete => :set_null
      String :description, :null=>false
      Numeric :base
      Date :date
      Numeric :iva
      Numeric :irpf
      String :status
      String :url
      DateTime :created_at
    end
  end
  down do
    alter_table :invoices do
      drop_constraint 'fk_invoices_user_id'
    end
    drop_table :invoices
  end
end