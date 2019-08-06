module Loaders
  class HttpLoader < Base
    def call
      url = feed.url
      raise "#{self.class.name} requires valid feed url" unless url.present?
      RestClient.get(url).body
    end
  end
end
