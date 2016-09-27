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
      [first_image_url]
    rescue
      []
    end

    def first_image_url
      @first_image_url ||= Service::Html.first_image_url(entity.description)
    end

    def excerpt
      @excerpt ||= Service::Html.excerpt(entity.description)
    end
  end
end
