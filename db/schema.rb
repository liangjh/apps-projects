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

ActiveRecord::Schema.define(:version => 20120615062219) do

  create_table "attrib_categories", :force => true do |t|
    t.string   "code",        :null => false
    t.string   "name",        :null => false
    t.string   "description"
    t.boolean  "visible"
    t.boolean  "multi"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attrib_categories", ["code"], :name => "index_attrib_categories_on_code"
  add_index "attrib_categories", ["name"], :name => "index_attrib_categories_on_name"

  create_table "attribs", :force => true do |t|
    t.integer  "attrib_category_id", :null => false
    t.string   "code",               :null => false
    t.string   "name",               :null => false
    t.string   "description"
    t.integer  "ord"
    t.boolean  "visible"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attribs", ["attrib_category_id"], :name => "index_attribs_on_attrib_category_id"
  add_index "attribs", ["code"], :name => "index_attribs_on_code"
  add_index "attribs", ["name"], :name => "index_attribs_on_name"

  create_table "authentications", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authentications", ["user_id"], :name => "index_authentications_on_user_id"

  create_table "metadata_keys", :force => true do |t|
    t.string   "code",        :null => false
    t.string   "name",        :null => false
    t.string   "description"
    t.string   "meta_type"
    t.boolean  "multi"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "metadata_keys", ["code"], :name => "index_metadata_keys_on_code"
  add_index "metadata_keys", ["name"], :name => "index_metadata_keys_on_name"

  create_table "metadata_values", :force => true do |t|
    t.integer  "saint_id",        :null => false
    t.integer  "metadata_key_id", :null => false
    t.string   "value"
    t.text     "value_text"
    t.integer  "ord"
    t.boolean  "visible"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "metadata_values", ["metadata_key_id"], :name => "index_metadata_values_on_metadata_key_id"
  add_index "metadata_values", ["saint_id"], :name => "index_metadata_values_on_saint_id"

  create_table "saint_attribs", :force => true do |t|
    t.integer  "saint_id",   :null => false
    t.integer  "attrib_id",  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "saint_attribs", ["attrib_id"], :name => "index_saint_attribs_on_attrib_id"
  add_index "saint_attribs", ["saint_id", "attrib_id"], :name => "index_saint_attribs_on_saint_id_and_attrib_id", :unique => true
  add_index "saint_attribs", ["saint_id"], :name => "index_saint_attribs_on_saint_id"

  create_table "saint_edit_audits", :force => true do |t|
    t.integer  "saint_id",   :null => false
    t.string   "edited_by",  :null => false
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "saints", :force => true do |t|
    t.string   "symbol",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "saints", ["symbol"], :name => "index_saints_on_symbol", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "super_user"
    t.string   "username"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
