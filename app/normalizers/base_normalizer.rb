class BaseNormalizer < FeedService
  # @param [FeedEntity]
  # @return [Post]
  def normalize(feed_entity)
    raise AbstractMethodError
  end
end
