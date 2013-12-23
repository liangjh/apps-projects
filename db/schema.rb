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

ActiveRecord::Schema.define(:version => 20131223001006) do

  create_table "binomial_dists", :force => true do |t|
    t.integer  "n_trials"
    t.integer  "x_success"
    t.float    "p_population"
    t.float    "p_cum"
    t.float    "p_point"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "binomial_dists", ["n_trials", "p_population"], :name => "index_binomial_dists_on_n_trials_and_p_population"
  add_index "binomial_dists", ["n_trials", "x_success"], :name => "index_binomial_dists_on_n_trials_and_x_success"

  create_table "t_dists", :force => true do |t|
    t.integer  "df"
    t.float    "alpha"
    t.float    "p_cum"
    t.float    "tv_2t"
    t.float    "tv_1t"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "t_dists", ["df", "alpha"], :name => "index_t_dists_on_df_and_alpha"
  add_index "t_dists", ["df", "tv_1t"], :name => "index_t_dists_on_df_and_tv_1t"
  add_index "t_dists", ["df", "tv_2t"], :name => "index_t_dists_on_df_and_tv_2t"

  create_table "z_dists", :force => true do |t|
    t.float    "zv"
    t.float    "p_lt_zv"
    t.float    "p_gt_zv"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "z_dists", ["p_gt_zv"], :name => "index_z_dists_on_p_gt_zv"
  add_index "z_dists", ["p_lt_zv"], :name => "index_z_dists_on_p_lt_zv"
  add_index "z_dists", ["zv"], :name => "index_z_dists_on_zv"

end
