class AddImportLimitToFeeds < ActiveRecord::Migration[5.2]
  def change
    add_column :feeds, :import_limit, :integer
  end
end
