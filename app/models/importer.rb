class Importer < ActiveRecord::Base
  belongs_to :user
    
  STATUS = {
    :pending => 1,
    :in_progress => 2,
    :success => 3,
    :failed => 4
  }

  attr_accessible :file_name, :directory_name, :status, :error_msg, :uploaded_at, :user_id
  
end