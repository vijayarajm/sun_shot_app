module UsersHelper
  
  def user_filters
    [
      ["Username is", :username],
      ["First name is", :first_name],
      ["Last name is", :last_name],
      ["Email is", :email],
    ]
  end

  def role_list
    Role.all.collect{ |r| [r.name, r.id] }
  end

end