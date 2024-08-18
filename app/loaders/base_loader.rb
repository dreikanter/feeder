class BaseLoader < FeedService
  # @return [FeedContent]
  # @raise [LoaderError] when content loading failed
  def load
    raise AbstractMethodError
  end
end
