Sequel.migration do
  up do
    self[:clients].insert(:name => 'Nicemondays SCP', :cif => 'J92682345', :address => 'Cno. Antiguo Paso del Ferrocarril Edificio Horizontes, 2 10aA 29640 Fuengirola (Malaga)', :created_at => Time.now)
    self[:clients].insert(:name => 'BeBanjoSL', :cif => 'B85450864', :address => 'Paseo de la Castellana, 178 1o Izq. 28046 Madrid Spain', :created_at => Time.now)
  end
  down do
    self[:clients].where(:cif => 'J92682345').delete
    self[:clients].where(:cif => 'B85450864').delete
  end
end