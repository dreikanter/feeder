module Loaders
  class HttpLoader < Base
    def call
      url = feed.url
      raise "#{self.class.name} requires valid feed url" unless url.present?

      RestClient.get(url).body
    rescue StandardError => e
      raise [
        "error fetching feed: '#{feed.name}'",
        "url: '#{url}'",
        e.class.name,
        e.message
      ].join('; ')
    end
  end
end
