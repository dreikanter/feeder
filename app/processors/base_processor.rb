class BaseProcessor
  attr_reader :feed

  def initialize(feed)
    @feed = feed
  end

  # @param [FeedContent]
  # @return [Array<FeedEntity>]
  def process(feed_content)
    raise AbstractMethodError
  end
end
