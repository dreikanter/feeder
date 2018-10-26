module Service
  class FeedLoader
    extend Dry::Initializer

    param :feed

    def self.call(feed)
      new(feed).call
    end

    def call
      refreshed_at = Time.new.utc
      return processor.process(feed_content).lazy
    rescue
      refreshed_at = nil
      raise
    ensure
      feed.update(refreshed_at: refreshed_at)
    end

    private

    def processor
      Service::ProcessorResolver.call(feed)
    end

    def feed_content
      RestClient.get(feed.url).body if feed.url
    end
  end
end
