require 'import_methods.rb'

class ImportersController < ApplicationController
  include ImportMethods

  # 'deny_access' to check if users are logged in.
  # 
  # 'validate_zip' and 'check_for_metadata_csv' - to validate the ZIP file uploaded.
  # 
  # GET /importers - Lists all import files uploaded with file_names, statuses and error_messages.
  # 
  # POST /importer - Uploads ZIP and starts importing the data in a separate thread file by file. 
  # 
  # GET /importer/status - URL which updates the import status of all the files.

  before_filter :deny_access
  before_filter :validate_zip, :check_for_metadata_csv, :remove_hidden_files, :only => :create

  def create
    add_zip(params[:ZIP])

    flash[:notice] = "Your upload will begin shortly..."
    redirect_to importers_path
  end

  def index
    @imports = Import.paginate(:page => params[:page], :per_page => 30)
  end

  def status
    @imports = Import.paginate(:page => params[:page], :per_page => 30)
    render :partial => 'import_list'
  end

  private
    def validate_zip      
      unless File.extname(params[:ZIP].original_filename).eql?(".zip")
        flash[:error] = "Please upload only ZIP files."
        return redirect_to importers_path
      end
      
      begin
        Zip::File.open(params[:ZIP].path)
      rescue
        flash[:error] = "The ZIP file you uploaded is not supported!"
        return redirect_to importers_path
      end
    end

    def check_for_metadata_csv
      files_in_zip = []
      Zip::File.open(params[:ZIP].path) do |zip_file|
        files_in_zip = zip_file.collect{ |entry| entry.name.split('/').last }
      end

      unless files_in_zip.include?(METADATA_FILE)
        flash[:error] = "The metadata.csv file is not found in the ZIP file uploaded. Please check."
        redirect_to importers_path
      end
    end

    def remove_hidden_files
      file = params[:ZIP].path
      Zip::ZipFile.open(file) do |zip_file|
        files = zip_file.select(&:file?)
        files.each do |f|
          if f.name =~ /\.DS_Store|__MACOSX|(^|\/)\._/
            zip_file.remove(f.name)
          end
        end
      end
    end

end