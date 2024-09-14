# Load content and generate posts for the specified feed. Raises an error
# in case feed processing is not possible.
#
class Importer
  include Logging

  attr_reader :feed, :options

  # @param feed: [Feed]
  def initialize(feed, options = {})
    @feed = feed
    @options = options
  end

  # Import feed content and persist new posts. Will raise an error if the feed
  # processing workflow should be interrupted.
  # @raise [FeedConfigurationError] if the feed is missing related classes
  def import
    logger.info("importing #{feed.readable_id}")
    ensure_services_resolved
    feed_content = load_content
    entities = process_feed_content(feed_content)
    build_posts(filter_new_entities(entities))
  end

  private

  def ensure_services_resolved
    feed.ensure_supported
  rescue StandardError => e
    track_feed_error(error: e, category: "configuration")
    raise e
  end

  # @return [FeedContent]
  # @raise [StandardError] if processor execution is not possible
  def load_content
    loader_instance.load
  rescue StandardError => e
    track_feed_error(error: e, category: "loading")
    raise e
  end

  # @return [Array<FeedEntity>]
  # @raise [StandardError] if content processing is not possible
  def process_feed_content(feed_content)
    processor_instance.process(feed_content)
  rescue StandardError => e
    track_feed_error(error: e, category: "processing", context: {feed_content: feed_content})
    raise e
  end

  # @return [Array<FeedEntity>]
  def filter_new_entities(entities)
    existing_uids = feed.posts.where(uid: entities.map(&:uid)).pluck(:uid)
    entities.filter { existing_uids.exclude?(_1.uid) }
  end

  def build_posts(feed_entities)
    feed_entities.each do |feed_entity|
      normalizer_class.new(feed_entity).normalize.save!
    rescue StandardError => e
      track_feed_error(error: e, category: "post_building", context: {feed_entity: feed_entity})
      next
    end
  end

  def loader_instance
    options[:loader_instance] || feed.loader_instance
  end

  def processor_instance
    options[:processor_instance] || feed.processor_instance
  end

  def normalizer_class
    options[:normalizer_class] || feed.normalizer_class
  end

  def track_feed_error(category:, error: nil, context: {})
    ActiveRecord::Base.transaction do
      feed.update!(errors_count: feed.errors_count.succ)

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
      feed_service_classes: feed.service_classes
    }
  end
end
