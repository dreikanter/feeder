module Processors
  class FeedjiraProcessor < Processors::Base
    def entities
      parse_source.map { |entity| [entity.url, entity] }.to_h
    end

    private

    def parse_source
      Feedjira::Feed.parse(source).entries
    rescue => e
      Rails.logger.error "error parsing feed: #{e}"
      []
    end
  end
end
