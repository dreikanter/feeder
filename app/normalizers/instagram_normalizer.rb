module Normalizers
  class InstagramNormalizer < Base
    SCRIPT_PATH = Rails.root.join('scripts', 'ig.js').freeze

    option :script_path, optional: true, default: -> { SCRIPT_PATH }

    BASE_URL = 'https://instagram.com/p/'.freeze
    TIMESTAMP_PATH = ['taken_at_timestamp'].freeze
    CAPTION_PATH = ['edge_media_to_caption', 'edges', 0, 'node', 'text'].freeze
    IMAGE_URL_PATH = ['display_url'].freeze

    protected

    def link
      [BASE_URL, entity['shortcode']].join
    end

    def published_at
      Time.at(entity.dig(*TIMESTAMP_PATH)).to_datetime
    end

    def text
      [entity.dig(*CAPTION_PATH), link].join(separator)
    end

    # TODO: Move script interaction to a service class
    def attachments
      @attachments ||= fetch_image_urls
    end

    def fetch_image_urls
      output = `node #{script_path} post #{entity['shortcode']}`
      JSON.parse(output)
    end
  end
end
