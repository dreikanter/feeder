module Processors
  class XkcdProcessor < Processors::RssProcessor
    def description(item)
      first_img_tag(item.description)['alt'] || ''
    end

    def extra(item)
      {
        image_url: first_img_tag(item.description)['src']
      }
    end

    def first_img_tag(html)
      parse_html(html).css('img').first
    end

    def parse_html(html)
      @parsed_html ||= {}
      @parsed_html[html] ||= Nokogiri::HTML(html)
    end
  end
end
