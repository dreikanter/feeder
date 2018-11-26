class AddUidToPosts < ActiveRecord::Migration[5.2]
  class Post < ActiveRecord::Base
  end

  def change
    add_column :posts, :uid, :string
    Post.update_all('uid = link')
    change_column :posts, :uid, :string, null: false
  end
end
