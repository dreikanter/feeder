module Service
  class Html
    def self.text(html)
      result = Nokogiri::HTML(html)
      result.css('br').each { |br| br.replace "\n" }
      result.text.squeeze(" ").gsub(/[ \n]{2,}/, "\n").strip
    end

    EXCERPT_DEFAULTS = {
      length: 0,
      omission: Const::Content::OMISSION,
      separator: ' '
    }

    def self.excerpt(html, options = {})
      otps = EXCERPT_DEFAULTS.merge(options)
      text(html).truncate(otps[:length], separator: otps[:separator],
        omission: otps[:omission])
    end

    POST_EXCERPT_DEFAULTS = {
      length: Const::Content::MAX_POST_LENGTH,
      omission: Const::Content::OMISSION,
      link: '',
      separator: ''
    }

    def self.post_excerpt(html, options = {})
      opts = POST_EXCERPT_DEFAULTS.merge(options)
      limit = opts[:length] - opts[:link].length - opts[:separator].length
      excerpt = excerpt(html, length: limit, omission: opts[:omission])
      [excerpt, opts[:link]].reject(&:blank?).join(opts[:separator])
    end

    def self.comment_excerpt(html)
      excerpt(html, Const::Content::MAX_COMMENT_LENGTH)
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

    def self.paragraphs(html)
      result = Nokogiri::HTML(html)
      result.css('br,p').each { |e| e.after "\n" }
      result.css('a').each {|e| e.after(" (#{e['href']})") }
      result.text.split(/\n/).reject(&:blank?)
    end
  end
end
