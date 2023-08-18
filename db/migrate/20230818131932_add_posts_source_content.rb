class AddPostsSourceContent < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :source_content, :jsonb, null: false, default: {}
  end
end
