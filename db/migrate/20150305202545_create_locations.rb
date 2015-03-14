class CreateLocations < ActiveRecord::Migration
  def up
    create_table :locations do |t|
      t.string :unique_id, :null => false
      t.string :name
      t.string :address
      t.string :maximum_output
      t.decimal :lat, :precision => 10, :default => 0.0, :null => false
      t.decimal :long, :precision => 10, :default => 0.0, :null => false

      t.timestamps
    end
  end

  def down
    drop_table :locations
  end

end
