# Copyright (C) 2015 TopCoder Inc., All Rights Reserved.
# 
# This file represents the data model of locations.
#
# Author TCSASSEMBLER
# Version 1.0

class Datum < ActiveRecord::Base
  set_table_name :location_data

  # Attributes that can be mass assigned in the location_data model
  attr_accessible :location_id, :date_time, :instantaneous_power
  
  # Validations to check presence of mandatory attributes
  validates :location_id, :date_time, :instantaneous_power, :presence => true

  belongs_to :location
end