class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.integer :feed_id, null: false
      t.string :title
      t.string :link, null: false
      t.string :description
      t.datetime :published_at
      t.string :guid
      t.json :extra, null: false, default: {}
      t.string :freefeed_post_id

      t.timestamps
    end

    add_index :posts, :feed_id
  end
end
