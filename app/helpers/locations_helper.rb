# Copyright (C) 2015 TopCoder Inc., All Rights Reserved.
# 
# This file has helper methods to build, format data displayed in the UI.
#
# Author: TCSASSEMBLER
# Version: 1.0

module LocationsHelper
  
  # Helper method to build location filter options

  def location_filters
    [
      ["Unique ID is", :unique_id],
      ["Name is", :name],
      ["Address is", :address],
      ["Maximum Output is", :maximum_output],
      ["Latitiude is", :lat],
      ["Longitude is", :long],
    ]
  end

end