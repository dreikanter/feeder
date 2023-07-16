# Update Feed records from a configuration file
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
    log_info("updating feeds from configuration")
    disable_missing_feeds
    create_or_update_feeds
  end

  private

  def disable_missing_feeds
    missing_feeds.update_all(state: :disabled)
  end

  def missing_feeds
    Feed.where.not(name: feed_names)
  end

  def feed_names
    feed_configurations.filter_map { |configuration| configuration[:name] }.uniq
  end

  def create_or_update_feeds
    feed_configurations.each { |configuration| FeedUpdater.new(**configuration).create_or_update }
  end

  def feed_configurations
    @feed_configurations ||= config_data.map { |config| FeedSanitizer.call(**config.symbolize_keys) }
  end

  def config_data
    YAML.load_file(path)
  end
end
