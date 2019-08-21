class NextbigfutureThumbnailFetcher
  include Callee

  param :url

  option(
    :client,
    optional: true,
    default: -> { ->(url) { RestClient.get(url).body } }
  )

  CSS_SELECTOR = '.featured-thumbnail img'.freeze

  def call
    html = client.call(url)
    elements = Nokogiri::HTML(html).css(CSS_SELECTOR)
    elements.first['src']
  rescue StandardError
    nil
  end
end
