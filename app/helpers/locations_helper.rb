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