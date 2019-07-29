module Normalizers
  class AerostaticaNormalizer < Normalizers::Base
    def link
      entity.url
    end

    def published_at
      entity.published
    end

    def text
      result = [entity.title, link].join(separator)
      record_url = fetch_record_url
      return result unless record_url.present?
      "#{result}\n\nЗапись эфира: #{record_url}"
    end

    def comments
      [description].reject(&:blank?)
    end

    private

    def image_url
      Service::Html.first_image_url(entity.content)
    end

    LINE_BREAK = %r{\n+|\<br\s*/?\>}.freeze

    def description
      excerpt = Service::Html.squeeze(entity.content)
      Service::Html.comment_excerpt(excerpt.to_s.gsub(LINE_BREAK, "\n\n"))
    end

    def fetch_record_url
      content = RestClient.get(link).body
      Service::AerostaticaRecordLinkExtractor.call(content)
    rescue StandardError => e
      message = "error fetching record url from #{link}"
      Rails.logger.error(message)
      Error.dump(e, class_name: self.class.name, hint: message)
      nil
    end
  end
end
