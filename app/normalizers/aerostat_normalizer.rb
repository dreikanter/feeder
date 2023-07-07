class AerostatNormalizer < BaseNormalizer
  def link
    content.url
  end

  def published_at
    content.published
  end

  def text
    "#{content.title}, #{link}\nЗапись: #{enclosure_url}"
  end

  def attachments
    [content.itunes_image]
  rescue StandardError
    []
  end

  def comments
    [summary]
  end

  private

  def summary
    Html.text(content.summary).gsub(/\s+/, " ").strip
  end

  delegate :enclosure_url, to: :content
end
