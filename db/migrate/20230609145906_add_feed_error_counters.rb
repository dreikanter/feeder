class AddFeedErrorCounters < ActiveRecord::Migration[6.1]
  def change
    add_column :feeds, :errors_count, :integer, null: false, default: 0
    add_column :feeds, :total_errors_count, :integer, null: false, default: 0
  end
end
