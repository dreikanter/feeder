class AddOptionsToFeeds < ActiveRecord::Migration[5.2]
  def change
    add_column :feeds, :options, :json, null: false, default: {}
  end
end
