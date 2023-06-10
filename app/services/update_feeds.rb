class UpdateFeeds
  include Callee

  DEFAULT_PATH = Rails.root.join('config/feeds.yml')

  option :path, optional: true, default: -> { DEFAULT_PATH }
  option :logger, optional: true, default: -> { Rails.logger }

  ALLOWED_ATTRIBUTES = %i[
    after
    import_limit
    loader
    name
    normalizer
    options
    processor
    refresh_interval
    url
  ].freeze

  def call
    logger.info('updating feeds from configuration')
    update_active_feeds
    deactivate_missing_feeds
  end

  def update_active_feeds
    feeds.each do |config|
      feed = Feed.find_or_create_by(name: config[:name])
      safe_config = config.slice(*ALLOWED_ATTRIBUTES)
      feed.update(**safe_config.merge(status: FeedStatus.active))
    end
  end

  def deactivate_missing_feeds
    missing_feeds.update_all(status: FeedStatus.inactive)
  end

  def missing_feeds
    active_feeds = feeds.pluck(:name)
    Feed.where.not(name: active_feeds)
  end

  def feeds
    @feeds ||= load_feeds.map { |feed| FeedSanitizer.call(**feed.symbolize_keys) }
  end

  def load_feeds
    feeds = YAML.load_file(path)
    raise 'feeds configuration should define a list' unless feeds.is_a?(Array)
    feeds
  end
end
