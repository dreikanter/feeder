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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160912110133) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "feeds", force: :cascade do |t|
    t.string   "name",                     null: false
    t.integer  "posts_count",  default: 0, null: false
    t.datetime "refreshed_at"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["name"], name: "index_feeds_on_name", unique: true, using: :btree
  end

  create_table "posts", force: :cascade do |t|
    t.integer  "feed_id",                       null: false
    t.string   "title"
    t.string   "link",                          null: false
    t.string   "description"
    t.datetime "published_at"
    t.string   "guid"
    t.json     "extra",            default: {}, null: false
    t.string   "freefeed_post_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["feed_id"], name: "index_posts_on_feed_id", using: :btree
  end

end
