class AddFeedSubscriptionsCount < ActiveRecord::Migration[5.2]
  def change
    add_column :feeds, :subscriptions_count, :integer, null: false, default: 0
  end
end
