class AddUsagesCountToServiceInstances < ActiveRecord::Migration[7.0]
  def change
    add_column :service_instances, :usages_count, :integer, null: false, default: 0
  end
end
