## Overview
The Solar Retina is a software platform that provides real-time intelligence of total “behind-the-meter” solar PV (Photovoltaics) generation on the distribution system. Using crowdsourced solar generation data from actual PVs on the distribution grid, software provides superior distributed solar generation analysis. 

This application forms the web admin portal to import and maintain Solar Retina system data. Live demo can be seen in this link - http://ec2-54-173-33-253.compute-1.amazonaws.com/


## Setup Prerequisites
1. [Ruby on Rails](http://www.rubyonrails.org) framework is used to build the application.
2. [Bootstrap](http://www.getbootstrap.com) is used for the frontend.
3. [MySQL](http://www.mysql.com) is used 


## Versions and other third party libraries used
1. Ruby 1.9.3
2. Rails 3.2.13
3. MySQL2
4. Authlogic 3.1.0
5. Will Paginate 3.0.3
6. rubyzip


## Installation
1. Unzip the app to the desired directory.

2. Install the required gems using bundler with the following command. 
    ```"bundle install"```
    Note: If you are using windows, make sure you have DevKit 4.5.2 for the bundler to succeed.

3. Edit ```config/database.yml``` and configure the database.
    i) Create a database from your mysql client.
    ii) Open database.yml and modify the values of database, username, host and password with the details of database you created.

4. Run ```"rake db:migrate"``` from the project root.

5. Run ```"rake populate_default_data:add_role_and_admin_user"``` to add the default admin role and the admin user.

6. Execute the following command to run the application.
    ```"rails s -p <port_name>"```


## Verification
1. Login ```(/login)```
  Login with "admin" as username and "admin" as password.
  Supports redirect param.

2. Location
    1. Model attributes - ```id, unique_id, name, address, maxmimum_output, lat, long```
        
    2. ```GET /locations``` - renders the locations page. Lists all locations with pagination in a table, which can be filtered.
        Request: ```/locations```
        Request params: ```unique_id, name, address, maxmimum_output, lat, long``` (all optional)
        Success response: 200 OK
        Failure response: -

    3. ```POST /locations``` - creates a new location record.
        Request: ```/locations```
        Request params: ```unique_id, name(optional), address(optional), maxmimum_output, lat, long```
        Success response: "Location created!"
        Failure response: "unique_id/maximum_output/lat/long can't be blank."

    4. ```PUT /locations/{id}``` - updates existing location with a given id.
        Request: ```/locations/{id}```
        Request params: ```unique_id, name(optional), address(optional), maxmimum_output, lat, long```
        Success response: "Location updated!"
        Failure response: "maximum_output/lat/long can't be blank."

    5. ```DELETE /locations``` - deletes existing locations given the location ids.
        Request: ```/locations```
        Request params: ```location_ids```
        Success response: "Locations deleted!"
        Failure response: -

3. Location Data Page
    1. Model attributes - ```id, location_id, date_time, instantaneous_power```

    2. ```GET /locations/{id}/data``` - render locations data page. Lists all location_data of the location with given id with pagination in a table
        Request: ```/locations/{id}/data```        
        Success response: 200 OK
        Failure response: -

    3. ```POST /locations/{location_id}/data``` - adds a new location data record for the given location.
        Request: ```/locations{location_id}/data```
        Request params: ```date_time, instantaneous_power```
        Success response: "Location data created!"
        Failure response: "date_time/instantaneous_power can't be blank."

    4. ```PUT /locations/{location_id}/data/{id}``` - update existing location data.
        Request: ```/locations/{location_id}/data/{ID}```
        Request params: ```date_time, instantaneous_power```
        Success response: "Location data UPDATED!"
        Failure response: "date_time/instantaneous_power can't be blank."

    5. ```DELETE /locations/{location_id}/data``` - deletes given location data
        Request: ```/locations/{location_id}/data```
        Request params: ```location_data_ids```
        Success response: "Location data deleted!"
        Failure response: -

4. Users page
    1. Model attributes - ```id, username, first_name, last_name, email, crypted_password, password_salt, perishable_token, persistence_token```

    2. ```GET /users``` - render users page. Lists all users - with pagination and filters.
        Request: ```/users```        
        Success response: 200 OK
        Failure response: -

    3. ```POST /users``` - adds a new user.
        Request: ```/users```
        Request params: ```id, username, first_name, last_name, email, password, role_ids```
        Success response: "User created!"
        Failure response: "username/first_name/last_name/email can't be blank.", "Password is too short. Email address should look like an email address. Username already taken"

    4. ```PUT /users/{id}``` - update existing user data.
        Request: ```/users/{id}```
        Request params: ```id, username, first_name, last_name, email, password```
        Success response: "User created!"
        Failure response: "username/first_name/last_name/email can't be blank.", "Password is too short. Email address should look like an email address. Username already taken"

    5. ```DELETE /users``` - deletes users with given user ids (except the default admin)
        Request: ```/users```
        Request params: ```user_ids```
        Success response: "Users deleted!"
        Failure response: -

5. Importers page
    1. Model attributes - ```id, status, file_name, directory_name, error_msg, uploaded_at```

    2. ```GET /importers``` - Lists all import files uploaded with file_names, statuses and error_messages.
        Request: ```/importers```        
        Success response: 200 OK
        Failure response: -

    3. ```POST /importer``` - Uploads ZIP and starts importing the data in a separate thread file by file. 
        Request: ```/importers``` 
        Request params: ZIP       
        Success response: 200 OK
        Failure response: "The metadata.csv file is not found in the ZIP file uploaded. Please check.", "Invalid ZIP. Each Unique ID in metadata.csv should have corresponding CSV file", "The ZIP file you uploaded is not supported!"


    4. ```GET /importer/status``` - URL which updates the import status of all the files.
        Request: ```/importers/status```
        Success response: 200 OK
        Failure response: -
        