# Copyright (C) 2015 TopCoder Inc., All Rights Reserved.
# 
# This file has helpder methods to build user filter options and roles
#
# Author: TCSASSEMBLER
# Version: 1.0

module UsersHelper
  
  # Helper method to build user filter options and roles
  
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