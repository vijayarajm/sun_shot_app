class CreateLocations < ActiveRecord::Migration
  def up
    create_table :locations do |t|
      t.string :unique_id
      t.string :name
      t.string :address
      t.string :maximum_output      
      t.string :lat
      t.string :long

      t.timestamps
    end
  end

  def down
    drop_table :locations
  end

end
