class CreateLocationData < ActiveRecord::Migration
  def up
    create_table :location_data do |t|
      t.integer :location_id, :null => false
      t.integer :date_time, :null => false
      t.decimal :instantaneous_power, :precision => 10, :default => 0.0, :null => false

      t.timestamps      
    end
  end

  def down
    drop_table :location_data
  end
end
