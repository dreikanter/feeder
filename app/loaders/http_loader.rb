module Loaders
  class HttpLoader < Base
    def call
      url = feed.url
      RestClient.get(url).body if url
    rescue StandardError => exception
      raise [
        "error fetching feed: '#{feed.name}'",
        "url: '#{url}'",
        exception.class.name,
        exception.message
      ].join('; ')
    end
  end
end
