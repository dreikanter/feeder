module Service
  class FeedLoader
    def self.load(feed_name)
      send(:new, feed_name).send(:load_entities)
    end

    private

    attr_reader :feed

    def initialize(feed_name)
      @feed = Feed.for(feed_name.to_s)
      raise "feed not found: #{feed_name}" unless @feed
    end

    def load_entities
      refreshed_at = Time.new.utc
      return processor.process(feed_content).lazy
    rescue
      refreshed_at = nil
      raise
    ensure
      feed.update(refreshed_at: refreshed_at)
    end

    def processor
      Service::ProcessorResolver.call(feed.name)
    end

    def feed_content
      RestClient.get(feed.url).body if feed.url
    end
  end
end
