class UpdatePostStatuses < ActiveRecord::Migration[5.0]
  def up
    Post.idle.where.not(freefeed_post_id: nil).update_all(status: :published)
  end

  def down
  end
end
