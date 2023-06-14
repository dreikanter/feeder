class FeedsConfiguration
  include Logging

  attr_reader :path

  DEFAULT_PATH = "config/feeds.yml".freeze

  def self.sync
    new(path: Rails.root.join(DEFAULT_PATH)).sync
  end

  # @param :path [String, Pathname] path to the feeds configuration file
  def initialize(path:)
    @path = path
  end

  # Synchronize Feeds records from the configuration file
  def sync
    logger.info("updating feeds from configuration")
    disable_missing_feeds
    create_ot_update_existing_feeds
  end

  private

  def disable_missing_feeds
    missing_feeds.update_all(state: :disabled)
  end

  def missing_feeds
    Feed.where.not(name: feeds_configuration.keys)
  end

  def create_ot_update_existing_feeds
    feeds_configuration.each do |feed_name, attributes|
      feed = Feed.find_or_create_by(name: feed_name)
      feed.update!(**attributes)
      feed.enable! if feed.may_enable?
    end
  end

  def feeds_configuration
    @feeds_configuration ||= config_data.to_h do |config|
      attributes = FeedSanitizer.call(**config.symbolize_keys)
      [attributes[:name], attributes.except(:name)]
    end
  end

  def config_data
    YAML.load_file(path)
  end
end
