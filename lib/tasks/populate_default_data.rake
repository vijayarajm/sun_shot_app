namespace :populate_default_data do

  desc "Adding admin role and default admin user"
  task :add_role_and_admin_user => :environment do
    role = Role.create(:name => "Admin", :description => "Has all privileges")
    user = User.create(user_data)
    user.roles = [role]
  end  

  def user_data
    {
      :username => "admin",
      :first_name => "admin",
      :last_name => "admin",
      :email => "admin@admin.com",
      :password => "admin"
    }
  end
end