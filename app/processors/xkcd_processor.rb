require 'rss'

module Processors
  class XkcdProcessor < Processors::Base
    def parse
      RSS::Parser.parse(source).items.map { |item| attrs(item) }
    end

    private

    def attrs(item)
      {
        title: item.title,
        link: item.link,
        description: item.description,
        published_at: item.pubDate,
        guid: item.guid ? item.guid.content : nil,
        extra: extra(item)
      }
    end

    def extra(item)
      image_attrs(first_img_tag(item.description)).to_json
    end

    def image_attrs(image)
      {
        image_description: image['alt'] || '',
        image_url: image['src']
      }
    end

    def first_img_tag(html)
      Nokogiri::HTML(html).css('img').first
    end
  end
end
