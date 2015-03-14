# Copyright (C) 2015 TopCoder Inc., All Rights Reserved.
# 
# This file includes the worker methods that carries on the import of data to the database.
#
# Author TCSASSEMBLER
# Version 1.0

require 'csv'

module ImportMethods
  
  DIRECTORY_NAME = "import_files"
  METADATA_FILE = "metadata.csv"

  # add_zip
  # 
  # This method creates a directory in the root path everytime a zip is uploaded and adds all 
  # unzipped files to it.
  # All import jobs are added to the imports table.
  # Calls import_data method if no import is currently going on.

  def add_zip(file_name)
    timestamp = Time.now.to_i
    directory_name = %(#{DIRECTORY_NAME}_#{timestamp})
    Dir.mkdir(directory_name)
    
    Zip::File.open(file_name.path) do |zip_file|
      zip_file.each do |entry|  
        if valid_csv?(entry) 
          entry_file_name = entry.name.split('/').last
          file_path = File.join("#{RAILS_ROOT}", directory_name, entry_file_name)          
          File.open(file_path, 'w') {|f| f.write(entry.get_input_stream.read) }
          add_import_job(entry_file_name, directory_name, Time.at(timestamp))
        end
      end
      import_data unless Import.find_by_status(Import::STATUS[:in_progress])
    end
  end

  # add_import_job
  # 
  # Creating the import job with the file name and directory name

  def add_import_job(file_name, directory_name, uploaded)
    Import.create(:file_name => file_name, :directory_name => directory_name, :uploaded_at => uploaded, 
      :status => Import::STATUS[:pending], :user_id => current_user.id)
  end

  # import_data
  # 
  # Starts reading the metadata.csv and the subsequent csv files.
  # This method is recursively called to check and run if there is any pending import.

  def import_data
    pending_import = Import.find_by_status(Import::STATUS[:pending])
    return if pending_import.blank?

    Thread.new{      
      directory_name = pending_import.directory_name
      locations_in_csv = read_metadata_csv(directory_name)
      read_other_csvs(directory_name)
      import_data
    }    
  end

  # read_metadata_csv
  # 
  # Reads metadata.csv of the uploaded zip. 
  # Creates/Updates location entries in the locations table.
  # Removes location entries that are not in the metadata.csv file.

  def read_metadata_csv(directory_name)
    import = Import.find_by_directory_name_and_file_name(directory_name, METADATA_FILE)
    locations_in_csv = []
    update_status(import, :in_progress)
    CSV.foreach(%(#{directory_name}/#{METADATA_FILE}), headers: true) do |row|
      begin
        locations_in_csv << row[0]
        location = Location.find_or_create_by_unique_id(row[0])
        p location
        location.update_attributes(:maximum_output => row[1], :lat => row[2], :long => row[3])
        update_status(import, :success)
      rescue Exception => e
        update_status(import, :failed, e)
      end
    end
    
    remove_missing_records(locations_in_csv)
  end

  def remove_missing_records(locations_in_csv)
    locations_not_in_csv = Location.all.collect{ |l| l.unique_id } - locations_in_csv
    locations_not_in_csv.each do |location_unique_id|
      location = Location.find_by_unique_id(location_unique_id)
      location.destroy if location
    end
  end

  # read_other_csvs
  # 
  # Reads other CSV files in the ZIP file and uploads the data.
  # Deletes existing data and adds the new data from the file.
  # If location not found for a CSV file, it is updated with failed status and not_found error msg.

  def read_other_csvs(directory_name)
    Import.find_all_by_directory_name(directory_name).each do |import|      
      if !import.file_name.eql?(METADATA_FILE) 
        update_status(import, :in_progress)
        unique_id = import.file_name.split(".csv")[0]
        location = Location.find_by_unique_id(unique_id)
        if location.present?
          delete_query = "DELETE FROM location_data where location_id = #{location.id}"
          ActiveRecord::Base.connection.execute(delete_query)

          CSV.foreach(%(#{directory_name}/#{import.file_name})) do |row|
            date_time = (row[1].to_i * 60) + 1388534400
            Datum.create(:location_id => location.id, :date_time => date_time, :instantaneous_power => row[1])
            update_status(import, :success)
          end
        else
          update_status(import, :failed, "Location with unique_id #{unique_id} not found")
        end
      end
    end
  end

  # update_status
  # 
  # Updates status of import files

  def update_status(import, status, error_msg = nil)
    import.update_attributes(:status => Import::STATUS[status], :error_msg => error_msg)
  end

  def valid_csv?(entry)
    entry.name.split('/').last.include?(".csv")
  end
end
