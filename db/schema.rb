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

ActiveRecord::Schema.define(:version => 20110216224038) do

  create_table "images", :force => true do |t|
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.string   "facebook_token"
    t.integer  "facebook_uid",       :limit => 8
    t.string   "facebook_email"
    t.integer  "tag_uid",            :limit => 8
    t.integer  "crop_x"
    t.integer  "crop_y"
    t.integer  "crop_width"
    t.integer  "crop_height"
    t.integer  "progess"
    t.text     "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
