module EntityNormalizers
  class MediumNormalizer < EntityNormalizers::RssNormalizer
    def text
      [super, "!#{link}"].reject(&:blank?).join(separator)
    end

    def attachments
      [image_url]
    rescue
      []
    end

    def comments
      [excerpt]
    rescue
      []
    end

    def image_url
      @image_url ||= description.
        css('.medium-feed-image img:first').first['src']
    end

    def description
      Nokogiri::HTML(entity.description)
    end

    def excerpt
      result = page_body
      result.css('br').each { |br| br.replace "\n" }
      result.css('h1').each { |h1| h1.replace '' }
      result.text.squeeze(' ').gsub(/\n{2,}/, "\n").
        truncate(Const::Content::MAX_COMMENT_LENGTH, separator: ' ',
          omission: Const::Content::OMISSION)
    end

    def page_body
      @page_body ||= Nokogiri::HTML(page_content).
        css('.section--body .section-content').first
    end

    def page_content
      RestClient.get(link).body
    end
  end
end
