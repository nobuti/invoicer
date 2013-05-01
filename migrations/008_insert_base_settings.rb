Sequel.migration do
  up do
    self[:settings].insert(:user_id => 1, :name => 'Miguel Romero Portero', :nif => '53683729G', :address => 'C/ Almansa, 4 3-C, 29007 Malaga', :iva => 21, :irpf => 21, :created_at => Time.now)
  end
  down do
    self[:settings].where(:user_id => 1).delete
  end
end