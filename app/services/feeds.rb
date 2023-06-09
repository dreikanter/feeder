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

  def load_and_update_feeds
    logger.info('updating feeds from configuration')
    remove_missing_feeds
    update_existing_feeds
  end

  def remove_missing_feeds
    # TODO
  end

  def update_existing_feeds
    # TODO
  end

  def feeds
    @feeds ||= config_data.map(&:symbolize_keys).map(&FeedSanitizer)
  end

  def config_data
    YAML.load_file(path)
  end
end
