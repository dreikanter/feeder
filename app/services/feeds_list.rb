# NOTE: Always use FeedsList to fetch active feeds list
#
class FeedsList
  include Callee

  DEFAULT_PATH = Rails.root.join('config', 'feeds.yml')

  option :path, optional: true, default: -> { DEFAULT_PATH }
  option :logger, optional: true, default: -> { Rails.logger }

  def call
    update_feeds if update_feeds?
    Feed.ordered_active
  end

  private

  def update_feeds
    logger.info('updating feeds from configuration')
    update_present_feeds
    deactivate_missing_feeds
    CreateDataPoint.call(:config)
  end

  def update_present_feeds
    feeds.each do |config|
      feed = Feed.find_or_create_by(name: config[:name])
      feed.update({ status: FeedStatus.active }.merge(config))
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

  def update_feeds?
    !feeds_update_time || config_update_time > feeds_update_time
  end

  def config_update_time
    File.mtime(path).to_datetime
  end

  def feeds_update_time
    @feeds_update_time ||= DataPoint.for(:config).last&.created_at
  end
end
