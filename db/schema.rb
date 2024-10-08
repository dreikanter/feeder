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

ActiveRecord::Schema[7.1].define(version: 2024_09_01_154501) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "error_reports", force: :cascade do |t|
    t.string "target_type"
    t.bigint "target_id"
    t.string "category"
    t.string "error_class", default: "", null: false
    t.string "file_name"
    t.integer "line_number"
    t.string "message", default: "", null: false
    t.string "backtrace", default: [], null: false, array: true
    t.jsonb "context", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category"], name: "index_error_reports_on_category"
    t.index ["target_type", "target_id"], name: "index_error_reports_on_target"
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
    t.datetime "occured_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
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
    t.datetime "refreshed_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "url"
    t.string "processor"
    t.string "normalizer"
    t.datetime "after", precision: nil
    t.integer "refresh_interval", default: 0, null: false
    t.json "options", default: {}, null: false
    t.string "loader"
    t.integer "import_limit"
    t.datetime "last_post_created_at", precision: nil
    t.integer "subscriptions_count", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.string "state", default: "pristine", null: false
    t.integer "errors_count", default: 0, null: false
    t.integer "total_errors_count", default: 0, null: false
    t.datetime "state_updated_at", precision: nil
    t.string "source_url", default: "", null: false
    t.string "description", default: "", null: false
    t.string "disabling_reason", default: "", null: false
    t.datetime "configured_at"
    t.index ["name"], name: "index_feeds_on_name", unique: true
    t.index ["status"], name: "index_feeds_on_status"
  end

  create_table "nitter_instances", force: :cascade do |t|
    t.string "status", null: false
    t.string "url", null: false
    t.datetime "errored_at", precision: nil
    t.integer "errors_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["errored_at"], name: "index_nitter_instances_on_errored_at"
    t.index ["status"], name: "index_nitter_instances_on_status"
    t.index ["url"], name: "index_nitter_instances_on_url"
  end

  create_table "posts", id: :serial, force: :cascade do |t|
    t.integer "feed_id", null: false
    t.string "link", default: "", null: false
    t.datetime "published_at", precision: nil, null: false
    t.string "text", default: "", null: false
    t.string "attachments", default: [], null: false, array: true
    t.string "comments", default: [], null: false, array: true
    t.string "freefeed_post_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "status", default: 0, null: false
    t.string "uid", null: false
    t.string "validation_errors", default: [], null: false, array: true
    t.string "state", default: "draft", null: false
    t.jsonb "source_content", default: {}, null: false
    t.index ["feed_id"], name: "index_posts_on_feed_id"
    t.index ["link"], name: "index_posts_on_link"
    t.index ["status"], name: "index_posts_on_status"
  end

  create_table "service_instances", force: :cascade do |t|
    t.string "service_type", null: false
    t.string "state", null: false
    t.string "url", null: false
    t.integer "errors_count", default: 0, null: false
    t.integer "total_errors_count", default: 0, null: false
    t.datetime "used_at", precision: nil
    t.datetime "failed_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "usages_count", default: 0, null: false
    t.index ["service_type", "url"], name: "index_service_instances_on_service_type_and_url", unique: true
    t.index ["state"], name: "index_service_instances_on_state"
  end

  create_table "sparklines", force: :cascade do |t|
    t.bigint "feed_id"
    t.jsonb "data", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["feed_id"], name: "index_sparklines_on_feed_id"
  end

end
