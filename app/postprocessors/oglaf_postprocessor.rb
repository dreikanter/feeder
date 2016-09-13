module Postprocessors
  class OglafPostprocessor < Postprocessors::Base
    def process(entity)
      re = RestClient.get(entity['link'])

      unless re.code == 200
        raise "error downloading '#{entity['link']}'; http code: #{re.code}"
      end

      image = Nokogiri::HTML(re.body).css('img#strip').first

      entity.merge(
        'published_at' => last_modified(re),
        'attachments' => [image[:src]]
      )
    end

    def last_modified(response)
      DateTime.parse response.headers[:last_modified]
    rescue
      DateTime.now
    end
  end
end
