class CreateUserRoles < ActiveRecord::Migration
  def up
    create_table :user_roles do |t|
      t.integer :user_id, :null => false
      t.integer :role_id, :null => false
    end
  end

  def down
    drop_table :user_roles
  end
end
