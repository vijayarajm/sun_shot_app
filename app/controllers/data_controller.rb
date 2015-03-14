# Copyright (C) 2015 TopCoder Inc., All Rights Reserved.
# 
# This controller has CRUD methods to perform actions on location_data
#
# Author: TCSASSEMBLER
# Version: 1.0

class DataController < ApplicationController

  before_filter :deny_access, :check_for_location
  
  # 'deny_access' to check if users are logged in.
  # 
  # 'scoper' identifies the location with the given ID
  # 
  # 'check_for_location' to check if location_id exists.
  # 
  # create: POST /locations/{location_id}/data - adds a new location data record for the given location.
  # 
  # update: PUT /locations/{location_id}/data/{id} - update existing location data.
  # 
  # index: GET /locations/{id}/data - renders locations data page. Lists all location_data of 
  # the location with given id with pagination in a table
  # 
  # destroy: DELETE /locations/{location_id}/data - deletes given location data

  def new
    @location_data = scoper.data.new
  end

  def create
    @location_data = scoper.data.new(params[:location_data])

    if @location_data.save
      flash[:notice] = "Location data created!"
      redirect_to location_data_path
    else
      flash[:notice] = @location_data.errors.full_messages.uniq.to_sentence
      redirect_to location_data_path
    end
  end

  def edit
    @location_data = scoper.data.find_by_id(params[:id])
  end

  def update
    @location_data = scoper.data.find_by_id(params[:id])
    
    if @location_data.update_attributes(params[:datum])
      flash[:notice] = "Location data updated!"
      redirect_to location_data_path
    else
      flash[:notice] = @location_data.errors.full_messages.uniq.to_sentence
      redirect_to location_data_path
    end
  end

  def index    
    @location_data = scoper.data.paginate(:page => params[:page], :per_page => 30)
  end

  def destroy_multiple
    locations = scoper.data.where(:id => params[:location_data_ids])
    locations.destroy_all

    flash[:notice] = "Location data deleted!"
    redirect_to location_data_path
  end

  private
    def scoper
      Location.find_by_id(params[:location_id])
    end

    def check_for_location
      unless scoper
        flash[:error] = "The page you are looking for doesn't exist"
        redirect_to locations_path
      end
    end
end