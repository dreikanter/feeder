module Postprocessors
  class DilbertPostprocessor < Postprocessors::Base
    def process(entity)
      re = RestClient.get(entity['link'])

      unless re.code == 200
        raise "error downloading '#{entity['link']}'; http code: #{re.code}"
      end

      entity.merge('attachments' => [image_url(re.body)])
    end

    def image_url(html)
      Nokogiri::HTML(html).css('img.img-comic').first[:src]
    end
  end
end
