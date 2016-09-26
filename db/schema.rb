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

ActiveRecord::Schema.define(version: 20160926170407) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "data_point_series", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.index ["name"], name: "index_data_point_series_on_name", unique: true, using: :btree
  end

  create_table "data_points", force: :cascade do |t|
    t.integer  "series_id"
    t.json     "details",    default: {}, null: false
    t.datetime "created_at",              null: false
    t.index ["series_id"], name: "index_data_points_on_series_id", using: :btree
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

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
    t.string   "link",                          null: false
    t.datetime "published_at",                  null: false
    t.string   "text",             default: "", null: false
    t.string   "attachments",      default: [], null: false, array: true
    t.string   "comments",         default: [], null: false, array: true
    t.string   "freefeed_post_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "status",           default: 0,  null: false
    t.index ["feed_id"], name: "index_posts_on_feed_id", using: :btree
    t.index ["link"], name: "index_posts_on_link", using: :btree
    t.index ["status"], name: "index_posts_on_status", using: :btree
  end

end
