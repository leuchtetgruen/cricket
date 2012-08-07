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

ActiveRecord::Schema.define(:version => 20120807092711) do

  create_table "issues", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "type"
    t.integer  "user_id"
    t.integer  "software_id"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.boolean  "resolved",       :default => false
    t.string   "reporter_name"
    t.string   "reporter_email"
  end

  create_table "messages", :force => true do |t|
    t.integer  "issue_id"
    t.integer  "user_id"
    t.text     "text"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "softwares", :force => true do |t|
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "password"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.string   "salt"
    t.boolean  "admin"
    t.integer  "type",       :default => 0
  end

end
