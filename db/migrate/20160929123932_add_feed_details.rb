class AddFeedDetails < ActiveRecord::Migration[5.0]
  def change
    add_column :feeds, :url, :string
    add_column :feeds, :processor, :string
    add_column :feeds, :normalizer, :string
  end
end
