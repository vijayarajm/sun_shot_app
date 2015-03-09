class User < ActiveRecord::Base
  
  attr_accessible :username, :first_name, :last_name, :email, :password, :role_ids
  validates :username, :first_name, :last_name, :email, :presence => true
  validates_uniqueness_of :username, :email

  has_many :importers
  has_and_belongs_to_many :roles,
    :join_table => :user_roles
  
  acts_as_authentic do |c|
    c.login_field :username
    c.validates_length_of_password_field_options = {:on => :update, :minimum => 4, :if => :has_no_credentials? }    
  end  

  private
    def has_no_credentials?
      self.crypted_password.blank?
    end
end