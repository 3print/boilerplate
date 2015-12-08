u = User.new
u.email = "admin@boilerplate.com"
u.password = u.password_confirmation = "adminboilerplate"
u.role = :admin
u.save!
