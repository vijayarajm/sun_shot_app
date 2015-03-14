# Copyright (C) 2015 TopCoder Inc., All Rights Reserved.
# 
# This file has helper methods to build, format data displayed in the UI.
#
# Author: TCSASSEMBLER
# Version: 1.0

module ApplicationHelper
  
  # This method checks if the user is signed in with the presence of current_user.
  def signed_in?
    !current_user.nil?
  end

  def formated_date(date)    
    date.to_datetime.strftime('%b %d, %Y')
  end

  def nav_tab_list
    [ 
      ["Locations", :locations, locations_path],
      ["Users", :users, users_path],
      ["Importers", :importers, importers_path],
    ]
  end
  
  def nav_tabs
    navigation = nav_tab_list.map do |tab|       
      content_tag(:li, link_to(tab[0], tab[2], 
          :class => ((@selected_tab == tab[1]) ? "active" : ""))).html_safe
    end    
    navigation.compact
  end

end
