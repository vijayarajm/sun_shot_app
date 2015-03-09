namespace :populate_default_data do

  desc "Adding admin role and default admin user"
  task :add_role_and_admin_user => :environment do
    Role.create(:name => "Admin", :description => "Has all privileges")
    User.create(user_data)
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