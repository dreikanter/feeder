# Data object representating a raw feed entity (like a blog post or RSS item).
#
# @see BaseProcessor
#
class FeedEntity
  attr_reader :feed, :uid, :content

  # @param feed: [Feed] source feed
  # @param uid: [String] unique entity identifier, like RSS item id
  #   or permalink URL
  # @content [Object] arbitrary content representation
  def initialize(feed:, uid:, content:)
    @feed = feed
    @uid = uid
    @content = content
  end
end
