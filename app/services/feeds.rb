class Feeds
  include Logging

  attr_reader :path

  # @param :path [String, Pathname] path to the feeds configuration file
  def initialize(path:)
    @path = path
  end

  # Synchronize Feeds records from the configuration file
  # @return [Array<Feed>] array of enabled feeds
  def list
    @list ||= update_and_load_feeds
  end

  private

  def update_and_load_feeds
    logger.info('updating feeds from configuration')
    remove_missing_feeds
    create_ot_update_existing_feeds
    Feed.enabled
  end

  def remove_missing_feeds
    missing_feeds.update_all(state: :removed)
  end

  def missing_feeds
    Feed.where.not(name: enabled_feed_names_from_configuration)
  end

  def create_ot_update_existing_feeds
    feeds_configuration.each do |config|
      feed = Feed.find_or_create_by(name: config[:name])
      feed.update!(config.merge(status: FeedStatus.active))
      feed.enable! if feed.may_enable?
    end
  end

  def enabled_feed_names_from_configuration
    feeds_configuration.map { |config| config[:name] }
  end

  def feeds_configuration
    @feeds ||= config_data.map(&:symbolize_keys).map(&FeedSanitizer)
  end

  def config_data
    YAML.load_file(path)
  end
end
