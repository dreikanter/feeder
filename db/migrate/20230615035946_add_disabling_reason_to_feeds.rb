class AddDisablingReasonToFeeds < ActiveRecord::Migration[6.1]
  def change
    add_column :feeds, :source, :string, null: false, default: ""
    add_column :feeds, :description, :string, null: false, default: ""
    add_column :feeds, :disabling_reason, :string, null: false, default: ""
  end
end
