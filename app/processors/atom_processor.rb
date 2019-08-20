require 'rss'

class AtomProcessor < BaseProcessor
  protected

  def entities
    parse_content.map { |i| [i.link.href, i] }.to_h
  end

  def parse_content
    RSS::Parser.parse(content, false).items
  rescue StandardError => e
    Rails.logger.error "error parsing atom feed: #{e}"
    []
  end
end
