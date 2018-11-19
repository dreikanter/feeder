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
    rescue StandardError => exception
      raise [
        "error fetching feed: '#{feed.name}'",
        "url: #{url}",
        exception.class.name,
        exception.message
      ].join('; ')
    end
  end
end
