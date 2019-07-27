module Service
  class FeedBuilder
    DEFAULT_CONF_FETCHER = ->(feed_name) { Service::FeedsList[feed_name] }

    def self.call(feed_name, conf_fetcher = DEFAULT_CONF_FETCHER)
      options = conf_fetcher.call(feed_name)
      raise 'feed configuration not found' unless options
      feed = Feed.find_or_create_by(name: options[:name])
      feed.update({ status: Enums::FeedStatus.active }.merge(options))
      feed
    end
  end
end
