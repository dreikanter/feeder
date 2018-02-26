require 'rss'

module Processors
  class AtomProcessor < Processors::Base
    def entities
      items.map { |i| [i.link.href, i] }
    end

    private

    def parse_source
      RSS::Parser.parse(source, false).items
    rescue => e
      Rails.logger.error "error parsing atom feed: #{e}"
      []
    end
  end
end
