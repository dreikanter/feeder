# State backfill:
#
# Status values:
# - idle: 0
# - ready: 1
# - published: 2
# - ignored: 3
# - not_valid: 4
# - error: 5
#
# scope = Post.where("created_at <= ?", DateTime.parse("Sat, 01 Jul 2023 14:15:16.356921000 UTC +00:00")); nil
# scope.where(status: 0).update_all(state: "rejected")
# scope.where(status: 2).update_all(state: "published")
# scope.where(status: 3).update_all(state: "rejected")
# scope.where(status: 4).update_all(state: "rejected")
# scope.where(status: 5).update_all(state: "failed")
#
class AddStateToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :state, :string, null: false, default: "draft"
  end
end
