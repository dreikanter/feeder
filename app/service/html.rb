module Service
  class Html
    def self.text(html)
      result = Nokogiri::HTML(html)
      result.css('br').each { |br| br.replace "\n" }
      result.text.squeeze(" ").gsub(/[ \n]{2,}/, "\n").strip
    end

    def self.excerpt(html, max_length)
      text(html).truncate(max_length, separator: ' ',
        omission: Const::Content::OMISSION)
    end

    def self.post_excerpt(html)
      excerpt(html, Const::Content::MAX_UNCOLLAPSED_POST_LENGTH)
    end

    def self.comment_excerpt(html)
      excerpt(Const::Content::MAX_COMMENT_LENGTH)
    end

    def self.image_urls(html, selector = nil)
      Nokogiri::HTML(html).css(selector || 'img').map { |e| e['src'] }
    end

    def self.first_image_url(html, selector = nil)
      image_urls(html, selector).first
    end

    def self.link_urls(html, selector = nil)
      Nokogiri::HTML(html).css(selector || 'a').map { |e| e['href'] }
    end

    def self.first_link_url(html, selector = nil)
      link_urls(html, selector).first
    end
  end
end
