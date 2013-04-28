Sequel.migration do
  up do
    add_column :tasks, :completed, Integer, :default => 0
  end
  down do
    drop_column :tasks, :completed
  end
end