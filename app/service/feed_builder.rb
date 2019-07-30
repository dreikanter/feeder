# Returns Feed entity mathing specified name, after making sure the feed
# exists and up to date with the configuration. Raise an error if the feed
# name is not recognized.
#
module Service
  class FeedBuilder
    DEFAULT_CONFIG = Service::FeedsList

    def self.call(feed_name, config = DEFAULT_CONFIG)
      feed_config = config[feed_name]
      raise 'feed configuration not found' unless feed_config
      feed = Feed.find_or_create_by(name: feed_name)
      feed.update({ status: Enums::FeedStatus.active }.merge(feed_config))
      feed
    end
  end
end
