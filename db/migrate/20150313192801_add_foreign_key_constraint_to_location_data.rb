class AddForeignKeyConstraintToLocationData < ActiveRecord::Migration
  change_table :location_data do |t|
    t.foreign_key :locations
  end
end
