class FeedEntity
  attr_reader :uid, :content, :feed

  def initialize(uid:, content:, feed:)
    @uid = uid.to_s
    @content = content
    @feed = feed
  end
end
