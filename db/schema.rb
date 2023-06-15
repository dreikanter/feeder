# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_06_15_035946) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "blocked_ips", force: :cascade do |t|
    t.inet "ip", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }
    t.index ["ip"], name: "index_blocked_ips_on_ip", unique: true
  end

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
    t.string "exception", default: "", null: false
    t.string "file_name"
    t.integer "line_number"
    t.string "label", default: "", null: false
    t.string "message", default: "", null: false
    t.string "backtrace", default: [], null: false, array: true
    t.json "context", default: {}, null: false
    t.datetime "occured_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "target_type"
    t.bigint "target_id"
    t.index ["exception"], name: "index_errors_on_exception"
    t.index ["file_name"], name: "index_errors_on_file_name"
    t.index ["occured_at"], name: "index_errors_on_occured_at"
    t.index ["status"], name: "index_errors_on_status"
    t.index ["target_type", "target_id"], name: "index_errors_on_target_type_and_target_id"
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
    t.integer "refresh_interval", default: 0, null: false
    t.json "options", default: {}, null: false
    t.string "loader"
    t.integer "import_limit"
    t.datetime "last_post_created_at"
    t.integer "subscriptions_count", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.string "state", default: "pristine", null: false
    t.integer "errors_count", default: 0, null: false
    t.integer "total_errors_count", default: 0, null: false
    t.datetime "state_updated_at"
    t.string "source", default: "", null: false
    t.string "description", default: "", null: false
    t.string "disabling_reason", default: "", null: false
    t.index ["name"], name: "index_feeds_on_name", unique: true
    t.index ["status"], name: "index_feeds_on_status"
  end

  create_table "nitter_instances", force: :cascade do |t|
    t.string "status", null: false
    t.string "url", null: false
    t.datetime "errored_at"
    t.integer "errors_count", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["errored_at"], name: "index_nitter_instances_on_errored_at"
    t.index ["status"], name: "index_nitter_instances_on_status"
    t.index ["url"], name: "index_nitter_instances_on_url"
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
    t.string "uid", null: false
    t.string "validation_errors", default: [], null: false, array: true
    t.index ["feed_id"], name: "index_posts_on_feed_id"
    t.index ["link"], name: "index_posts_on_link"
    t.index ["status"], name: "index_posts_on_status"
  end

end
