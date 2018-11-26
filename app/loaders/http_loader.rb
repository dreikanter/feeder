module Loaders
  class HttpLoader < Base
    def call
      url = feed.url
      raise "#{self.class.name} requires valid feed url" unless url.present?
      RestClient.get(url).body
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
