class CreateNitterInstances < ActiveRecord::Migration[6.1]
  def change
    create_table :nitter_instances do |t|
      t.string :status, null: false, index: true
      t.string :url, null: false
      t.datetime :errored_at, index: true
      t.integer :errors_count, null: false, default: 0
      t.timestamps
    end
  end
end
