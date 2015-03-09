class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :username
      t.string :first_name
      t.string :last_name
      t.string :email      
      t.string :crypted_password
      t.string :password_salt
      t.string :perishable_token
      t.string :persistence_token

      t.timestamps
    end
  end

  def down
    drop_table :users
  end
end
