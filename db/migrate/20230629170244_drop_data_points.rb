class DropDataPoints < ActiveRecord::Migration[6.1]
  def self.up
    drop_table :data_points
    drop_table :data_point_series
  end

  def self.down
    create_table :data_points do |t|
      t.integer :series_id, index: true
      t.json :details, null: false, default: {}
      t.datetime :created_at, null: false
    end

    create_table :data_point_series do |t|
      t.string :name, null: false, index: true
      t.datetime :created_at, null: false
    end
  end
end
