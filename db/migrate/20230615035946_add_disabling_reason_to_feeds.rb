class AddDisablingReasonToFeeds < ActiveRecord::Migration[6.1]
  def change
    add_column :feeds, :disabling_reason, :string
  end
end
