# Copyright (C) 2015 TopCoder Inc., All Rights Reserved.
# 
# This file represents the import model schema.
#
# Author TCSASSEMBLER
# Version 1.0

class Import < ActiveRecord::Base
  belongs_to :user
    
  # Constant which denotes the status of import files in the db.
  STATUS = {
    :pending => 1,
    :in_progress => 2,
    :success => 3,
    :failed => 4
  }

  # Attributes that can be mass assigned in import table
  attr_accessible :file_name, :directory_name, :status, :error_msg, :uploaded_at, :user_id
  
end