class FeedsConfigurator
  include Logging

  attr_reader :feeds_configuration

  def initialize(feeds_configuration: Rails.configuration.feeds)
    @feeds_configuration = feeds_configuration
  end

  def import
    feeds_configuration.each do |configuration|
      existing_feed = existing_feeds[configuration[:name]]
      attributes = feed_attributes(configuration)

      if existing_feed
        existing_feed.update!(**attributes) if existing_feed.configurable?
      else
        Feed.create!(**attributes)
      end
    end
  end

  private

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

  def existing_feeds
    @existing_feeds ||= Feed.where(name: feed_names).index_with(&:name)
  end

  def feed_names
    feeds_configuration.pluck(:name)
  end
end
