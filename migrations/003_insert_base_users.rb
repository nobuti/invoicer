Sequel.migration do
  up do
    self[:users].insert(:user => 'buti@nobuti.com', :password_hash => '$2a$10$SBlFZX5byScp4UCgOlBDA.6eq/PiCVIkg3QpjY4DPgJDbuo.H9e3S', :forgot_code => 'bbbdd51167e371b39893f4e20db3891b', :state => 1, :password_salt => '$2a$10$SBlFZX5byScp4UCgOlBDA.', :created_at => Time.now)
  end
  down do
    self[:users].where(:user => 'buti@nobuti.com').delete
  end
end