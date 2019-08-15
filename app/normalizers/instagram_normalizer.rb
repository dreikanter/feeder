module Normalizers
  class InstagramNormalizer < Base
    protected

    BASE_URL = 'https://instagram.com'.freeze
    TIMESTAMP_PATH = ['taken_at_timestamp'].freeze
    CAPTION_PATH = ['edge_media_to_caption', 'edges', 0, 'node', 'text'].freeze
    IMAGE_URL_PATH = ['display_url'].freeze

    def link
      [BASE_URL, instagram_user, entity['id']].join('/')
    end

    def published_at
      Time.at(entity.dig(*TIMESTAMP_PATH)).to_datetime
    end

    def text
      [caption, link].join(separator)
    end

    def attachments
      [image_url]
    end

    def caption
      entity.dig(*CAPTION_PATH)
    end

    def image_url
      entity.dig(*IMAGE_URL_PATH)
    end

    def instagram_user
      feed.options.fetch('instagram_user')
    end
  end
end
