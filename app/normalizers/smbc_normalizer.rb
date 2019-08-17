module Normalizers
  class SmbcNormalizer < Normalizers::Base
    option :content, optional: true, default: -> { RestClient.get(link).body }

    protected

    def link
      entity.link
    end

    def published_at
      entity.pubDate
    end

    def text
      [title, link].join(separator)
    end

    def attachments
      [image_url, hidden_image_url].reject(&:blank?)
    end

    def comments
      [description].reject(&:blank?)
    end

    private

    TITLE_PREFIX = /^Saturday Morning Breakfast Cereal - /.freeze

    def title
      entity.title.gsub(TITLE_PREFIX, '')
    end

    def parsed_description
      @parsed_description ||= Nokogiri::HTML(entity.description)
    end

    DESCRIPTION_PREFIX = /^Hovertext:\s*/.freeze

    def description
      first_paragraph = parsed_description.css('p').first.children.text
      first_paragraph.gsub(DESCRIPTION_PREFIX, '')
    rescue StandardError
      nil
    end

    def image_url
      parsed_description.css('img').first.attributes['src'].value
    rescue StandardError
      nil
    end

    def hidden_image_url
      html = Nokogiri::HTML(content)
      html.css('#aftercomic img').first.attributes['src'].value
    rescue StandardError
      nil
    end
  end
end
