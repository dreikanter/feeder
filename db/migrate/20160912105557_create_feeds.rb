class CreateFeeds < ActiveRecord::Migration[5.0]
  def change
    create_table :feeds do |t|
      t.string :name, null: false
      t.integer :posts_count, null: false, default: 0
      t.datetime :refreshed_at

      t.timestamps
    end

    add_index :feeds, :name, unique: true
  end
end
