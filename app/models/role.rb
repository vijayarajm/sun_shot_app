# Copyright (C) 2015 TopCoder Inc., All Rights Reserved.
# 
# This file represents the role model
#
# Author TCSASSEMBLER
# Version 1.0

class Role < ActiveRecord::Base
  # Attributes that can be mass assigned in roles table
  attr_accessible :name, :description
  
  has_and_belongs_to_many :users,
    :join_table => :user_roles
end