# Copyright (C) 2015 TopCoder Inc., All Rights Reserved.
# 
# Represents user model
#
# Author TCSASSEMBLER
# Version 1.0

class User < ActiveRecord::Base
  
  # Attributes that can be mass assigned in users table
  attr_accessible :username, :first_name, :last_name, :email, :password, :role_ids

  # Validations to check presence of mandatory fields and unique fields.
  validates :username, :first_name, :last_name, :email, :presence => true
  validates_uniqueness_of :username

  # associations to models
  has_many :imports
  has_and_belongs_to_many :roles,
    :join_table => :user_roles
  
  # Uses Authlogic for authentication. Defining the settings in the block below
  acts_as_authentic do |c|
    c.login_field :username
    c.validate_email_field = false
    c.validates_length_of_password_field_options = {:on => :update, :minimum => 4, :if => :has_no_credentials? }    
  end  

  private
    def has_no_credentials?
      self.crypted_password.blank?
    end
end