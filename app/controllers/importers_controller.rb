require 'import_methods.rb'

class ImportersController < ApplicationController
  include ImportMethods

  before_filter :deny_access


  def create
    add_zip(params[:CSV])

    flash[:notice] = "Your upload will begin shortly..."
    redirect_to importers_path
  end

  def index
    @imports = Importer.paginate(:page => params[:page], :per_page => 30)
  end

  def status
    @imports = Importer.paginate(:page => params[:page], :per_page => 30)
    render :partial => 'import_list'
  end
end