require 'rss'

class AtomProcessor < BaseProcessor
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
