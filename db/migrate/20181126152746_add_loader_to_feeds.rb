class AddLoaderToFeeds < ActiveRecord::Migration[5.2]
  def change
    add_column :feeds, :loader, :string
  end
end
