class CreateDataPointSeries < ActiveRecord::Migration[5.0]
  def change
    create_table :data_point_series do |t|
      t.string :name, null: false
      t.datetime :created_at, null: false
    end

    add_index :data_point_series, :name, unique: true
  end
end
