class CreateImports < ActiveRecord::Migration
  def up
    create_table :importers do |t|
      t.integer :status
      t.string :file_name
      t.datetime :uploaded_at
      t.integer :user_id

      t.timestamps
    end
  end

  def down
    drop_table :importers
  end
end
