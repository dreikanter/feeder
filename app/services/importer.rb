# Load content and generate posts for the specified feed. Raises an error
# in case feed processing is not possible.
#
class Importer
  include Logging

  attr_reader :feed

  # @param feed: [Feed]
  def initialize(feed:)
    @feed = feed
  end

  # Import feed content and persist new posts. Will raise an error if the feed
  # processing workflow should be interrupted.
  # @raise [FeedConfigurationError] if the feed is missing related classes
  def import
    logger.info("importing #{feed.readable_id}")
    ensure_services_resolved
    feed_content = load_content(feed)
    entities = process_feed_content(feed_content)
    build_posts(entities)
  end

  private

  def ensure_services_resolved
    feed.ensure_supported
  rescue StandardError => e
    track_feed_error(error: e, category: "configuration")
  end

  # @return [FeedContent]
  # @raise [StandardError] if processor execution is not possible
  def load_content(feed)
    feed.loader_instance.load
  rescue StandardError => e
    track_feed_error(error: e, category: "loading")
    raise e
  end

  # @return [Array<FeedEntity>]
  # @raise [StandardError] if content processing is not possible
  def process_feed_content(feed_content)
    feed.processor_instance.process(feed_content)
  rescue StandardError => e
    track_feed_error(error: e, category: "processing", context: {content: feed_content})
    raise e
  end

  def build_posts(entities)
    entities.each do |entity|
      PostBuilder.new(feed: feed, feed_entity: entity).build
    end
  end

  def track_feed_error(category:, error: nil, context: {})
    ActiveRecord::Base.transaction do
      feed.update!(errored_at: Time.current, errors_count: feed.errors_count.succ)

      ErrorReporter.report(
        error: error,
        target: feed,
        category: category,
        context: context.merge(error_context)
      )
    end
  end

  def error_context
    {
      feed_supported: feed.supported?,
      feed_service_classes: feed.service_classes
    }
  end
end