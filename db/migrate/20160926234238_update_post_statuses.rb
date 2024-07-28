class UpdatePostStatuses < ActiveRecord::Migration[5.0]
  def up
    # Replace "idle" status with "published"
    execute <<-SQL
      UPDATE posts
      SET status = 2
      WHERE status = 0 AND freefeed_post_id IS NOT NULL
    SQL
  end

  def down
  end
end
