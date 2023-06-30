class NextbigfutureThumbnailFetcher
  include Callee

  param :url

  option(
    :client,
    optional: true,
    default: -> { ->(url) { RestClient.get(url).body } }
  )

  def call
    html = client.call(url)
    elements = Nokogiri::HTML(html).css(".featured-image img.attachment-full")
    elements.first["src"]
  rescue StandardError
    nil
  end
end
