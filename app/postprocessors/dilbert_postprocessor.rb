module Postprocessors
  class DilbertPostprocessor < Postprocessors::Base
    def process(entity)
      re = RestClient.get(entity[:link])

      unless re.code == 200
        raise "error downloading '#{entity[:link]}'; http code: #{re.code}"
      end

      html = Nokogiri::HTML(re.body)
      entity.merge(
        extra: {
          image_url: image_url(html),
          tags: tags(html)
        }
      )
    end

    def image_url(html)
      html.css('img.img-comic').first[:src]
    end

    def tags(html)
      html.css('.comic-tags a').map { |e| e.content }
    rescue => e
      Rails.logger.error "error parsing tags: #{e}"
      []
    end
  end
end
