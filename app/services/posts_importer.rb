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
  # @raise [StandardError] will interrupt the flow on any loader or processor error
  def import
    feed.touch(:refreshed_at)
    processor_instance.process(loader_instance.content)
    reset_feed_errors_count
  rescue StandardError => e
    increment_feed_error_count
    raise
  end

  private

  def reset_feed_errors_count
    feed.update!(errors_count: 0)
  end

  def increment_feed_error_count
    feed.update!(errors_count: errors_count.succ, total_errors_count: total_errors_count.succ)
  end

  delegate :loader_instance, :processor_instance, :errors_count, :total_errors_count, to: :feed
end
