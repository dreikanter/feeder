class DilbertNormalizer < AtomNormalizer
  protected

  def text
    [title, super].join(separator)
  end

  def published_at
    DateTime.parse(link.split("/").last)
  rescue StandardError
    logger.error "error parsing date from url: #{link}"
    nil
  end

  def attachments
    @attachments ||= [image_url]
  end

  def title
    page_body.title.split(separator).first
  end

  def image_url
    page_body.css("img.img-comic:first").first[:src]
  end

  def page_body
    @page_body ||= Nokogiri::HTML(page_content)
  end

  def page_content
    RestClient.get(link).body
  end
end
