class BaseLoader
  attr_reader :feed

  def initialize(feed:)
    @feed = feed
  end

  # @return [FeedContent]
  def load
    raise AbstractMethodError
  end
end
