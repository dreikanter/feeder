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

    if PHOTON_HOST_PATTERN.match? parsed_uri.host
      replace_host_name(parsed_uri)
    else
      url
    end
  end

  PHOTON_HOST_PATTERN = /^i\d+\.wp\.com$/

  private_constant :PHOTON_HOST_PATTERN

  # :reek:TooManyStatements
  def replace_host_name(parsed_uri)
    original_path = parsed_uri.path
    original_query = parsed_uri.query
    original_host = original_path.split("/")[1]
    direct_url = "https://#{original_host}#{original_path}"
    original_query ? "#{direct_url}?#{original_query}" : direct_url
  end

  def cover_image
    Html.first_image_url(http.get(content.link).to_s)
  end
end
