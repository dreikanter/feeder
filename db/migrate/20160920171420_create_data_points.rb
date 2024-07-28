class CreateDataPoints < ActiveRecord::Migration[5.0]
  def change
    create_table :data_points do |t|
      t.integer :series_id
      t.json :details, null: false, default: {}
      t.datetime :created_at, null: false
    end

    add_index :data_points, :series_id
  end
end
