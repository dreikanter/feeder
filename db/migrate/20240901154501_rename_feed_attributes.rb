class RenameFeedAttributes < ActiveRecord::Migration[7.1]
  def change
    rename_column :feeds, :source, :source_url
    add_column :feeds, :configured_at, :datetime
  end
end
