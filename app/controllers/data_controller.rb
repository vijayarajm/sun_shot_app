class DataController < ApplicationController

  before_filter :deny_access, :check_for_location
  
  def new
    @location_data = scoper.data.new
  end

  def create
    @location_data = scoper.data.new(params[:location_data])

    if @location_data.save
      flash[:notice] = "Location data created!"
      redirect_to location_data_path
    else

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

    end
  end

  def index    
    @location_data = scoper.data.paginate(:page => params[:page], :per_page => 30)
  end

  def show
    
  end

  # def destroy
  #   location_datum = scoper.data.find_by_id(params[:id])
  #   p location_datum
  #   location_datum.destroy
    
  #   flash[:notice] = "Location datas destroyed!"
  #   redirect_to location_data_path
  # end

  def destroy
    locations = scoper.data.where(:id => params[:location_data_ids])
    locations.destroy_all

    flash[:notice] = "Location destroyed!"
    redirect_to location_data_path
  end

  def destroy_multiple
    locations = scoper.data.where(:id => params[:location_data_ids])
    locations.destroy_all

    flash[:notice] = "Locations deleted!"
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