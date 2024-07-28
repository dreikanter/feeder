class AddRefreshTimeToFeeds < ActiveRecord::Migration[5.2]
  def change
    add_column :feeds, :refresh_interval, :integer, null: false, default: 0
  end
end
