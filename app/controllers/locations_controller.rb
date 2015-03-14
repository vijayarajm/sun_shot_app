# Copyright (C) 2015 TopCoder Inc., All Rights Reserved.
# 
# This controller has CRUD methods to perform actions on locations
#
# Author: TCSASSEMBLER
# Version: 1.0

class LocationsController < ApplicationController

  # index: GET /locations - renders the locations page. Lists all locations
  # 
  # create: POST /locations - creates a new location record.
  # 
  # update: PUT /locations/{id} - updates existing location with the given id.
  # 
  # destroy: DELETE /locations - deletes existing locations given the location ids.
  # 
  # show: GET /location/{id} - renders location_data list of the location with the given id.
  # 
  # Uses raw mysql query to delete corresponding location_data values to reduce the number of 
  # queries fired. Else one delete query will be fired for each location_data row.

  before_filter :deny_access
  
  def new
    @location = Location.new
  end

  def create
    @location = Location.new(params[:location])

    if @location.save
      flash[:notice] = "Location created!"
      redirect_to locations_path
    else
      flash[:error] = @location.errors.full_messages.uniq.to_sentence
      redirect_to locations_path
    end
  end

  def edit
    @location = Location.find(params[:id])
  end

  def update
    @location = Location.find(params[:id])

    if @location.update_attributes(params[:location])
      flash[:notice] = "Location updated!"
      redirect_to locations_path
    else
      flash[:error] = @location.errors.full_messages.uniq.to_sentence
      redirect_to locations_path
    end
  end

  def index
    if params[:filter_param].present? and params[:filter_value].present?
      locations = Location.where("#{params[:filter_param]} = '#{params[:filter_value]}'")
      @locations = locations.paginate(:page => params[:page], :per_page => 30)
    else
      @locations = Location.paginate(:page => params[:page], :per_page => 30)
    end
  end  

  def show
    @location_data = Location.find(params[:id]).data.paginate(:page => params[:page], :per_page => 30)
  end

  def destroy_multiple
    locations = Location.where(:id => params[:location_ids])
    delete_query = "DELETE FROM location_data WHERE location_id IN (#{params[:location_ids].join(",")})"
    ActiveRecord::Base.connection.execute(delete_query)
    locations.destroy_all

    flash[:notice] = (locations.count > 1 ? "Locations deleted!" : "Location deleted!")
    redirect_to locations_path
  end

end