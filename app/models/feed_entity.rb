# Data object representating a raw feed entity (like a blog post or RSS item).
#
class FeedEntity
  attr_reader :feed, :uid, :content

  # @param uid: [String] unique entity identifier, like RSS item id
  #   or permalink URL
  # @content [Object] arbitrary content representation
  def initialize(uid:, content:)
    @uid = uid
    @content = content
  end
end
