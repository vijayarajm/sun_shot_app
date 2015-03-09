class Datum < ActiveRecord::Base
  set_table_name :location_data
  
  attr_accessible :location_id, :date_time, :instantaneous_power
  validates :location_id, :date_time, :instantaneous_power, :presence => true

  belongs_to :location
end