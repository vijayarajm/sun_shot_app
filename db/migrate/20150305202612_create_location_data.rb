class CreateLocationData < ActiveRecord::Migration
  def up
    create_table :location_data do |t|
      t.integer :location_id
      t.integer :date_time
      t.string :instantaneous_power

      t.timestamps
    end
  end

  def down
    drop_table :location_data
  end
end
