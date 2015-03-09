class Role < ActiveRecord::Base
  attr_accessible :name, :description
  
  has_and_belongs_to_many :users,
    :join_table => :user_roles
end