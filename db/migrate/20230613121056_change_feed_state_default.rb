class ChangeFeedStateDefault < ActiveRecord::Migration[6.1]
  def change
    add_column :feeds, :state_updated_at, :datetime

    reversible do |dir|
      dir.up do
        change_column :feeds, :state, :string, null: false, default: "pristine"
      end
      dir.down do
        change_column :feeds, :state, :string, null: false, default: "enabled"
      end
    end
  end
end
