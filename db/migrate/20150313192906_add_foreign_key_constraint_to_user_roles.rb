class AddForeignKeyConstraintToUserRoles < ActiveRecord::Migration
  change_table :user_roles do |t|
    t.foreign_key :users
    t.foreign_key :roles
  end
end
