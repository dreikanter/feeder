class FeedEntity
  attr_reader :uid, :content, :feed

  def initialize(uid:, content:, feed:)
    @uid = uid
    @content = content
    @feed = feed
  end
end
