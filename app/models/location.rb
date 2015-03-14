class Location < ActiveRecord::Base
  
  attr_accessible :unique_id, :name, :address, :maximum_output, :lat, :long
  validates :unique_id, :maximum_output, :lat, :long, :presence => true

  has_many :data, :dependent => :destroy
end