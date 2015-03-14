class CreateImports < ActiveRecord::Migration
  def up
    create_table :imports do |t|
      t.integer :status, :null => false
      t.string :file_name, :null => false
      t.string :directory_name, :null => false
      t.text :error_msg
      t.datetime :uploaded_at, :null => false
      t.integer :user_id, :null => false

      t.timestamps
    end
  end

  def down
    drop_table :imports
  end
end
