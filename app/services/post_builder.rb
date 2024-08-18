# Hydrate new Post instance from a FeedEntity. Always returns a valid Post,
# though it may not be suitable for publication depending on the content.
#
class PostBuilder
  attr_reader :feed, :feed_entity

  def initialize(feed:, feed_entity:)
    @feed = feed
    @feed_entity = feed_entity
  end

  # @return [Post]
  def build
    # TBD
    Post.new(feed: feed)
  end
end
