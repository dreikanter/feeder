class AddPostStatus < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :status, :integer, null: false, default: 0
    add_index :posts, :status
  end
end
