class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.integer :feed_id, null: false
      t.string :link, null: false
      t.datetime :published_at, null: false
      t.string :text, null: false, default: ''
      t.string :attachments, null: false, array: true, default: []
      t.string :comments, null: false, array: true, default: []
      t.string :freefeed_post_id
      t.timestamps
    end

    add_index :posts, :feed_id
    add_index :posts, :link
  end
end
