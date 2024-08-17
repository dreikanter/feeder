class BaseProcessor
  attr_reader :feed, :content

  def initialize(feed:, content:)
    @feed = feed
    @content = content
  end

  # @return [Array<FeedEntity>]
  def process
    raise AbstractMethodError
  end
end
