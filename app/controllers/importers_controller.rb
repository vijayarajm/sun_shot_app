# Copyright (C) 2015 TopCoder Inc., All Rights Reserved.
# 
# This controller takes care of import - validation, spanning threads for import proces and updating 
# status.
#
# Author: TCSASSEMBLER
# Version: 1.0

require 'import_methods.rb'

class ImportersController < ApplicationController
  include ImportMethods

  # 'deny_access' to check if users are logged in.
  # 
  # 'validate_zip_format', 'remove_hidden_files' and 'validate_zip' - to validate the ZIP file uploaded.
  # 'validate_zip_format' checks if the uploaded file is of the "ZIP" format.
  # 'remove_hidden_files' removes all hidden files like .DS_Store,etc from the uploaded ZIP.
  # 'validate_zip' checks if metadata.csv is present. Also, checks if all unique ids in metadata.csv 
  #  has corresponding CSVs. 
  # 
  # GET /importers - Lists all import files uploaded with file_names, statuses and error_messages.
  # 
  # POST /importer - Uploads ZIP and starts importing the data in a separate thread file by file. 
  # 
  # GET /importer/status - URL which updates the import status of all the files.

  before_filter :deny_access
  before_filter :validate_zip_format, :remove_hidden_files, :validate_zip, :only => :create

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
    def validate_zip_format
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

    def validate_zip
      files_in_zip =[]
      locations = []

      Zip::File.open(params[:ZIP].path) do |zip_file|
        zip_file.each do |entry|           
          files_in_zip << entry.name.split('/').last
          if entry.name.include?("metadata.csv")             
            content = entry.get_input_stream.read
            content.split("\r\n").each_with_index do |row, index|
              locations << row.split(",")[0] unless index == 0              
            end
          end
        end
      end

      unless files_in_zip.include?(METADATA_FILE)
        flash[:error] = "The metadata.csv file is not found in the ZIP file uploaded. Please check."
        return redirect_to importers_path
      end

      locations.each do |location_unique_id|
        unless files_in_zip.include?(%(#{location_unique_id}.csv))
          flash[:error] = "Invalid ZIP. Each Unique ID in metadata.csv should have corresponding CSV file"
          return redirect_to importers_path
        end
      end
    end

end