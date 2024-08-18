class CreateErrorReports < ActiveRecord::Migration[7.1]
  def change
    create_table :error_reports do |t|
      t.references "target", polymorphic: true, index: true
      t.string "category", index: true
      t.string "error_class", default: "", null: false
      t.string "file_name"
      t.integer "line_number"
      t.string "message", default: "", null: false
      t.string "backtrace", default: [], null: false, array: true
      t.jsonb "context", default: {}, null: false

      t.timestamps
    end
  end
end
