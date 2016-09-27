module Service
  class Html
    def self.text(html)
      result = Nokogiri::HTML(html)
      result.css('br').each { |br| br.replace "\n" }
      result.text.squeeze(" ").gsub(/\n{2,}/, "\n")
    end

    def self.excerpt(html)
      text(html).truncate(Const::Content::MAX_COMMENT_LENGTH, separator: ' ',
        omission: Const::Content::OMISSION)
    end

    def self.image_urls(html, selector = nil)
      Nokogiri::HTML(html).css(selector || 'img').map { |img| img['src'] }
    end

    def self.first_image_url(html, selector = nil)
      image_urls(html, selector).first
    end
  end
end
