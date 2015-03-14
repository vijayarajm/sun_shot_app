# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20150313192947) do

  create_table "imports", :force => true do |t|
    t.integer  "status",         :null => false
    t.string   "file_name",      :null => false
    t.string   "directory_name", :null => false
    t.text     "error_msg"
    t.datetime "uploaded_at",    :null => false
    t.integer  "user_id",        :null => false
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "imports", ["user_id"], :name => "imports_user_id_fk"

  create_table "location_data", :force => true do |t|
    t.integer  "location_id",                                                       :null => false
    t.integer  "date_time",                                                         :null => false
    t.decimal  "instantaneous_power", :precision => 10, :scale => 0, :default => 0, :null => false
    t.datetime "created_at",                                                        :null => false
    t.datetime "updated_at",                                                        :null => false
  end

  add_index "location_data", ["location_id"], :name => "location_data_location_id_fk"

  create_table "locations", :force => true do |t|
    t.string   "unique_id",                                                    :null => false
    t.string   "name",                                                         :null => false
    t.string   "address",                                                      :null => false
    t.string   "maximum_output",                                               :null => false
    t.decimal  "lat",            :precision => 10, :scale => 0, :default => 0, :null => false
    t.decimal  "long",           :precision => 10, :scale => 0, :default => 0, :null => false
    t.datetime "created_at",                                                   :null => false
    t.datetime "updated_at",                                                   :null => false
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "parent"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "user_roles", :force => true do |t|
    t.integer "user_id", :null => false
    t.integer "role_id", :null => false
  end

  add_index "user_roles", ["role_id"], :name => "user_roles_role_id_fk"
  add_index "user_roles", ["user_id"], :name => "user_roles_user_id_fk"

  create_table "users", :force => true do |t|
    t.string   "username",          :null => false
    t.string   "first_name",        :null => false
    t.string   "last_name",         :null => false
    t.string   "email",             :null => false
    t.string   "crypted_password",  :null => false
    t.string   "password_salt",     :null => false
    t.string   "perishable_token",  :null => false
    t.string   "persistence_token", :null => false
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_foreign_key "imports", "users", name: "imports_user_id_fk"

  add_foreign_key "location_data", "locations", name: "location_data_location_id_fk"

  add_foreign_key "user_roles", "roles", name: "user_roles_role_id_fk"
  add_foreign_key "user_roles", "users", name: "user_roles_user_id_fk"

end
