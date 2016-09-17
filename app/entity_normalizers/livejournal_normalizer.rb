module EntityNormalizers
  class LivejournalNormalizer < EntityNormalizers::RssNormalizer
    # https://freefeed-product.hackpad.com/LtsQ2rM1RGD
    MAX_COMMENT_LENGTH = 1500
    OMISSION = '... (continued)'

    def text
      [entity.title, entity.link].reject(&:blank?).join(' - ')
    end

    def comments
      [excerpt]
    end

    def attachments
      image ? [image] : []
    end

    def image
      @image ||= description.
        css('img:first').first.try(:[], 'src')
    end

    def excerpt
      result = description
      result.css('br').each { |br| br.replace "\n" }
      result.text.squeeze(" ").gsub(/\n{2,}/, "\n").
        truncate(MAX_COMMENT_LENGTH, separator: ' ', omission: OMISSION)
    end

    def description
      Nokogiri::HTML(entity.description)
    end
  end
end
