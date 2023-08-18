class ChangePostsLinkDefault < ActiveRecord::Migration[7.0]
  def change
    change_column_default :posts, :link, from: nil, to: ""
  end
end
