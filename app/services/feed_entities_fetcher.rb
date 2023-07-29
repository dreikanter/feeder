class FeedEntitiesFetcher
  attr_reader :feed

  def initialize(feed)
    @feed = feed
  end

  # @return [Array<FeedEntity>] array of processed feed entities
  # @raise [StandardError] pass feed loader and processor exceptions
  def fetch
    process(load_content)
  end

  private

  def load_content
    feed.loader_class.new(feed).content
  end

  def process(content)
    feed.processor_class.new(feed: feed, content: content).entities
  end
end
