class BaseProcessor < FeedService
  # @param [FeedContent]
  # @return [Array<FeedEntity>]
  def process(feed_content:)
    raise AbstractMethodError
  end
end
