class UpdateFeeds
  include Callee

  DEFAULT_PATH = Rails.root.join('config', 'feeds.yml')

  option :path, optional: true, default: -> { DEFAULT_PATH }
  option :logger, optional: true, default: -> { Rails.logger }

  def call
    logger.info('updating feeds from configuration')
    update_active_feeds
    deactivate_missing_feeds
  end

  def update_active_feeds
    feeds.each do |config|
      feed = Feed.find_or_create_by(name: config[:name])
      feed.update(config.merge(status: FeedStatus.active))
    end
  end

  def deactivate_missing_feeds
    missing_feeds.update_all(status: FeedStatus.inactive)
  end

  def missing_feeds
    active_feeds = feeds.map { |feed| feed[:name] }
    Feed.where('name NOT IN (?)', active_feeds)
  end

  def feeds
    @feeds ||= load_feeds
      .map(&:symbolize_keys)
      .map(&FeedSanitizer)
  end

  def load_feeds
    feeds = YAML.load_file(path)
    raise 'feeds configuration should define a list' unless feeds.is_a?(Array)
    feeds
  end
end
