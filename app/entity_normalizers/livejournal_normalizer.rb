module EntityNormalizers
  class LivejournalNormalizer < EntityNormalizers::RssNormalizer
    # https://freefeed-product.hackpad.com/LtsQ2rM1RGD

    def text
      [entity.title, "!#{entity.link}"].reject(&:blank?).join(' - ')
    end

    def comments
      [excerpt]
    end

    def attachments
      [image]
    rescue
      []
    end

    def image
      @image ||= description.css('img:first').first['src']
    end

    def excerpt
      result = description
      result.css('br').each { |br| br.replace "\n" }
      result.text.squeeze(" ").gsub(/\n{2,}/, "\n").
        truncate(Const::Content::MAX_COMMENT_LENGTH, separator: ' ',
          omission: Const::Content::OMISSION)
    end

    def description
      Nokogiri::HTML(entity.description)
    end
  end
end
