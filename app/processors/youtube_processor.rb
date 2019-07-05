# TODO: Use Feedjira processor instead

module Processors
  class YoutubeProcessor < Processors::Base
    protected

    def entities
      parse_source.map { |entity| [entity.url, entity] }.to_h
    end

    def parse_source
      Feedjira::Feed.parse(source).entries
    rescue => e
      Rails.logger.error "error parsing feed: #{e}"
      []
    end
  end
end
