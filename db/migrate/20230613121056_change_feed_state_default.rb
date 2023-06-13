class ChangeFeedStateDefault < ActiveRecord::Migration[6.1]
  def change
    change_column :feeds, :state, :string, null: false, default: "pristine"
  end
end
