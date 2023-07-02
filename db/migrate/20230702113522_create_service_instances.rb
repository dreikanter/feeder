class CreateServiceInstances < ActiveRecord::Migration[6.1]
  def change
    create_table :service_instances do |t|
      t.string :service_type, null: false
      t.string :state, null: false, index: true
      t.string :url, null: false
      t.integer :errors_count, null: false, default: 0
      t.integer :total_errors_count, null: false, default: 0
      t.datetime :used_at
      t.datetime :failed_at
      t.timestamps
    end

    add_index :service_instances, [:service_type, :url], unique: true
  end
end
