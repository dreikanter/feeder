module Service
  class FeedFinder
    def self.call(name)
      options = Service::FeedsList.call.find { |feed| feed['name'] == name }
      return unless options
      feed = Feed.find_or_create_by(name: options['name'])
      feed.update(options)
      feed
    end
  end
end
