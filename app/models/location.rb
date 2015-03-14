# Copyright (C) 2015 TopCoder Inc., All Rights Reserved.
# 
# This file represents the location model
#
# Author TCSASSEMBLER
# Version 1.0

class Location < ActiveRecord::Base
  
  # Attributes that can be mass assigned in location table
  attr_accessible :unique_id, :name, :address, :maximum_output, :lat, :long
  
  # Validations to check presence of mandatory attributes
  validates :unique_id, :maximum_output, :lat, :long, :presence => true

  has_many :data, :dependent => :destroy
end