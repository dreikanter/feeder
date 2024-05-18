class PluralisticNormalizer < RssNormalizer
  include HttpClient

  def text
    [super, link].join(separator)
  end

  def attachments
    [extract_direct_image_url(cover_image)]
  rescue StandardError
    super
  end

  private

  def extract_direct_image_url(url)
    parsed_uri = URI.parse(url)
    return url unless parsed_uri.host =~ /^i\d+\.wp\.com$/.freeze

    original_path = parsed_uri.path
    original_query = parsed_uri.query
    original_host = original_path.split("/")[1]

    original_url = "https://#{original_host}#{original_path.sub("/#{original_host}", '')}"
    original_query ? "#{original_url}?#{original_query}" : original_url
  end

  def cover_image
    Html.first_image_url(http.get(content.link).to_s)
  end
end
