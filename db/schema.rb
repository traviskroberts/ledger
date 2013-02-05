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

ActiveRecord::Schema.define(:version => 20130205012015) do

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "balance",    :default => 0
    t.string   "url"
  end

  create_table "accounts_users", :id => false, :force => true do |t|
    t.integer "account_id"
    t.integer "user_id"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "entries", :force => true do |t|
    t.integer  "account_id"
    t.string   "description"
    t.string   "classification"
    t.integer  "amount"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.date     "date"
  end

  create_table "invitations", :force => true do |t|
    t.integer  "account_id"
    t.integer  "user_id"
    t.string   "email"
    t.string   "token"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "recurring_transactions", :force => true do |t|
    t.integer  "account_id"
    t.integer  "day"
    t.integer  "amount"
    t.string   "classification"
    t.string   "description"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "perishable_token"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.datetime "last_request_at"
    t.integer  "login_count"
    t.string   "last_login_ip"
    t.string   "current_login_ip"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.boolean  "super_admin",       :default => false
    t.string   "name"
  end

end
