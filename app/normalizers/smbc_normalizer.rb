module Normalizers
  class SmbcNormalizer < Normalizers::Base
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
      [image_url, hidden_img].reject(&:blank?)
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
    rescue
      nil
    end

    def image_url
      parsed_description.css('img').first.attributes['src'].value
    rescue
      nil
    end

    def hidden_img
      content = Nokogiri::HTML(page_content)
      content.css('#aftercomic img').first.attributes['src'].value
    rescue
      nil
    end

    def page_content
      RestClient.get(link).body
    end
  end
end
