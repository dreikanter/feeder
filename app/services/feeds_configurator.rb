class FeedsConfigurator
  include Logging

  attr_reader :feeds_configuration

  def initialize(feeds_configuration: Rails.configuration.feeder.feeds)
    @feeds_configuration = feeds_configuration
  end

  def import
    feeds_configuration.each do |configuration|
      feed = existing_feeds_index[configuration[:name]]
      attributes = feed_attributes(**configuration)

      if feed
        update_existing_feed(feed, **attributes) if feed.configurable?
      else
        create_new_feed(attributes)
      end
    end
  end

  private

  def update_existing_feed(feed, attributes = {})
    if feed.update(**attributes)
      logger.info("feed updated: #{attributes[:name]}")
    else
      logger.error("error updating feed; attributes: #{attributes.to_json}; errors: #{feed.errors}")
    end
  end

  def create_new_feed(attributes)
    feed = Feed.new(**attributes)

    if feed.save
      logger.info("new feed created: #{attributes[:name]}")
    else
      logger.error("error creating new feed; attributes: #{attributes.to_json}; errors: #{feed.errors.to_json}")
    end
  end

  def feed_attributes(**configuration)
    {
      **configuration,
      configured_at: configured_at,
      updated_at: configured_at
    }
  end

  # @return [DateTime] memoized configuration timestamp
  def configured_at
    @configured_at ||= Time.current
  end

  def existing_feeds_index
    @existing_feeds_index ||= Feed.where(name: feed_names).index_by(&:name)
  end

  def feed_names
    feeds_configuration.pluck(:name)
  end
end
