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
      opts = EXCERPT_DEFAULTS.merge(options)
      text(html).truncate(opts[:length], separator: opts[:separator],
        omission: opts[:omission])
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

    HASHTAG_PATTERN = /(?:\s*|^)#[[:graph:]]+/

    def self.paragraphs(html)
      result = Nokogiri::HTML(html)

      # Replace paragraphs with line breaks
      result.css('br,p').each { |e| e.after "\n" }

      result.css('a').each do |e|
        href = e['href']

        # Replace linked URLs with plain text URLs
        e.replace(href) if href.start_with?(e.content.sub(/…$/, ''))

        # Unlink hashtags
        e.replace(e.content) if e.content =~ HASHTAG_PATTERN
      end

      # Replace links with plain text URLs
      result.css('a').each { |e| e.after(" (#{e['href']})") }

      result.text.split(/\n/).reject(&:blank?)
    end

    EMOJI_CHARS = [
      ['\u{1f600}', '\u{1f64f}'],
      ['\u{2702}',  '\u{27b0}'],
      ['\u{1f680}', '\u{1f6ff}'],
      ['\u{24C2}',  '\u{1F251}'],
      ['\u{1f300}', '\u{1f5ff}']
    ]

    EMOJI_PATTERN =
      Regexp.new(EMOJI_CHARS.map { |chars| chars.join('-') }.join)

    def self.strip_emoji(text)
      text.force_encoding('utf-8').encode.gsub(EMOJI_PATTERN, '')
    end
  end
end
