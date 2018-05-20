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

ActiveRecord::Schema.define(version: 20180520150306) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "data_point_series", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.index ["name"], name: "index_data_point_series_on_name", unique: true
  end

  create_table "data_points", id: :serial, force: :cascade do |t|
    t.integer "series_id"
    t.json "details", default: {}, null: false
    t.datetime "created_at", null: false
    t.index ["series_id"], name: "index_data_points_on_series_id"
  end

  create_table "delayed_jobs", id: :serial, force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "errors", id: :serial, force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.string "error_class_name", default: "", null: false
    t.string "file_name"
    t.integer "line_number"
    t.string "label", default: "", null: false
    t.string "message", default: "", null: false
    t.string "backtrace", default: [], null: false, array: true
    t.string "filtered_backtrace", default: [], null: false, array: true
    t.json "context", default: {}, null: false
    t.datetime "occured_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["error_class_name"], name: "index_errors_on_error_class_name"
    t.index ["file_name"], name: "index_errors_on_file_name"
    t.index ["occured_at"], name: "index_errors_on_occured_at"
    t.index ["status"], name: "index_errors_on_status"
  end

  create_table "feeds", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.integer "posts_count", default: 0, null: false
    t.datetime "refreshed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "url"
    t.string "processor"
    t.string "normalizer"
    t.datetime "after"
    t.index ["name"], name: "index_feeds_on_name", unique: true
  end

  create_table "posts", id: :serial, force: :cascade do |t|
    t.integer "feed_id", null: false
    t.string "link", null: false
    t.datetime "published_at", null: false
    t.string "text", default: "", null: false
    t.string "attachments", default: [], null: false, array: true
    t.string "comments", default: [], null: false, array: true
    t.string "freefeed_post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0, null: false
    t.index ["feed_id"], name: "index_posts_on_feed_id"
    t.index ["link"], name: "index_posts_on_link"
    t.index ["status"], name: "index_posts_on_status"
  end

end
