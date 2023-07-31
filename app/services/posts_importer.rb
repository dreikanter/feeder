# Uses a loader to fetch content, and feeds the content to a processor.
# Execution result is draft Post records with newly imported content.
#
class PostsImporter
  include Logging

  attr_reader :feed

  def initialize(feed)
    @feed = feed
  end

  # @return [Array<String>] array of newly created posts
  # @raise [StandardError] will interrupt the flow and pass any loader
  #   and processor errors; also will raise if the feed does not have
  #   a resolvable loader of processor
  def import
    feed.processor_class.new(feed: feed, content: load_content).process
  end

  private

  def load_content
    feed.loader_class.new(feed).content
  end
end
