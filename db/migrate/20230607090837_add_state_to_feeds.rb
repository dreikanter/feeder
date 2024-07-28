class AddStateToFeeds < ActiveRecord::Migration[6.1]
  def change
    add_column :feeds, :state, :string, null: false, default: "enabled"
  end
end
