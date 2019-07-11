require 'rss'

module Processors
  class AtomProcessor < Processors::Base
    protected

    def entities
      parse_source.map { |i| [i.link.href, i] }.to_h
    end

    def parse_source
      RSS::Parser.parse(source, false).items
    rescue StandardError => e
      Rails.logger.error "error parsing atom feed: #{e}"
      []
    end
  end
end
