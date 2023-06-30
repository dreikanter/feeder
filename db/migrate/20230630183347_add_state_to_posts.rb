class AddStateToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :state, :string, null: false, default: "draft"
  end
end
