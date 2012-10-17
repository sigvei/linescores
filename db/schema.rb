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

ActiveRecord::Schema.define(:version => 20121017112144) do

  create_table "ends", :force => true do |t|
    t.integer  "match_id"
    t.integer  "position"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "our_score"
    t.integer  "their_score"
  end

  create_table "matches", :force => true do |t|
    t.string   "opponent"
    t.datetime "time"
    t.string   "location"
    t.string   "tournament"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.boolean  "our_first_hammer"
    t.string   "our_lead"
    t.string   "our_second"
    t.string   "our_third"
    t.string   "our_fourth"
    t.string   "our_alternate"
    t.string   "their_lead"
    t.string   "their_second"
    t.string   "their_third"
    t.string   "their_fourth"
    t.string   "their_alternate"
    t.integer  "our_skip"
    t.integer  "their_skip"
    t.integer  "our_viceskip"
    t.integer  "their_viceskip"
  end

end
