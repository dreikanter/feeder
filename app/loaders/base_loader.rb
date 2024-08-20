class BaseLoader
  attr_reader :feed

  def initialize(feed)
    @feed = feed
  end

  # @return [FeedContent]
  # @raise [LoaderError] when content loading failed
  def load
    raise AbstractMethodError
  end
end
