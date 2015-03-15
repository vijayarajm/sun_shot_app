class CreateRoles < ActiveRecord::Migration
  def up
    create_table :roles do |t|
      t.string :name, :null => false
      t.string :description, :null => false
      t.string :parent

      t.timestamps
    end
  end

  def down
    drop_table :roles
  end
end
