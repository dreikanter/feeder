class AddLastPostCreatedAtToFeeds < ActiveRecord::Migration[5.2]
  def change
    add_column :feeds, :last_post_created_at, :datetime
  end
end
