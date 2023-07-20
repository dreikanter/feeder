class KotakuCommentsCountLoader
  include HttpClient

  attr_reader :post_url

  def initialize(post_url)
    @post_url = post_url
  end

  def comments_count
    Integer(element.attr("data-replycount"))
  end

  private

  def element
    Nokogiri::HTML(html).css("[data-replycount]").first
  end

  def html
    http.get(post_url).to_s
  end
end
