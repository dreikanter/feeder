module Normalizers
  class TwitterNormalizer < Normalizers::Base
    def valid?
      !options['only_with_attachments'] || images.any?
    end

    def validation_errors
      'no images'
    end

    def link
      "https://twitter.com/#{user_name}/status/#{entity_id}"
    end

    def published_at
      Time.parse(entity.fetch('created_at'))
    end

    def text
      [entity.fetch('text'), "!#{link}"].join(separator)
    end

    def images
      @images ||= entity.dig('extended_entities', 'media') || []
    end

    def attachments
      images.map { |image| image['media_url_https'] }
    end

    def entity_id
      entity.fetch('id')
    end

    def user_name
      entity.fetch('user').fetch('screen_name')
    end
  end
end
