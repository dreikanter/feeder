class RssNormalizer < BaseNormalizer
  delegate :link, to: :content

  def published_at
    content.respond_to?(:pubDate) ? content.send(:pubDate) : content.dc_date
  end

  def text
    content.title
  end
end
