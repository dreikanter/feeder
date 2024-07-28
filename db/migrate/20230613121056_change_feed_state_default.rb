class ChangeFeedStateDefault < ActiveRecord::Migration[6.1]
  def change
    add_column :feeds, :state_updated_at, :datetime
    change_column_default :feeds, :state, from: "enabled", to: "pristine"
  end
end
