module Service
  class FeedLoader
    extend Dry::Initializer

    param :feed

    def self.call(feed)
      new(feed).call
    end

    def call
      url = feed.url
      RestClient.get(url).body if url
    end
  end
end
