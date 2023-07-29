# Create or update a Feed record using FeedSanitizer data
class FeedUpdater
  attr_reader :name, :enabled, :updatable_attributes

  def initialize(name:, enabled:, attributes:)
    @name ||= name
    @enabled ||= enabled
    @updatable_attributes ||= attributes.symbolize_keys.slice(*Feed::CONFIGURABLE_ATTRIBUTES)
  end

  def create_or_update
    Feed.transaction do
      feed.update!(updatable_attributes)
      feed.ensure_supported
      update_feed_state
    end
  end

  private

  def update_feed_state
    enabled ? (feed.enable! if feed.may_enable?) : (feed.disable! if feed.may_disable?)
  end

  def feed
    @feed ||= Feed.find_or_create_by(name: name)
  end
end
