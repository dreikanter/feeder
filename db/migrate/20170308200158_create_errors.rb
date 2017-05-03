class CreateErrors < ActiveRecord::Migration[5.0]
  def change
    create_table "errors" do |t|
      t.integer  "status",             default: 0,  null: false, index: true
      t.string   "error_class_name",   default: "", null: false, index: true
      t.string   "file_name", index: true
      t.integer  "line_number"
      t.string   "label",              default: "", null: false
      t.string   "message",            default: "", null: false
      t.string   "backtrace",          default: [], null: false, array: true
      t.string   "filtered_backtrace", default: [], null: false, array: true
      t.json     "context",            default: {}, null: false
      t.datetime "occured_at",                      null: false, index: true
      t.timestamps
    end
  end
end
