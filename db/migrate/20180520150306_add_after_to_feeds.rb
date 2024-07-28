class AddAfterToFeeds < ActiveRecord::Migration[5.1]
  def change
    add_column :feeds, :after, :datetime
  end
end
