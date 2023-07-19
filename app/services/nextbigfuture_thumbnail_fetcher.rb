class NextbigfutureThumbnailFetcher
  attr_reader :page_uri

  def initialize(page_uri)
    @page_uri = page_uri
  end

  def fetch
    image_uri if http_uri?
  rescue StandardError
    nil
  end

  private

  # Ensure this is not a data image
  def http_uri?
    Addressable::URI.parse(image_uri).scheme == "https"
  end

  def image_uri
    @image_uri ||= image_element["src"]
  end

  def image_element
    Nokogiri::HTML(page_content).css(".featured-image noscript img").first
  end

  def page_content
    HTTP.use(:request_tracking).get(page_uri).to_s
  end
end
