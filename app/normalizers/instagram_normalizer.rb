class InstagramNormalizer < BaseNormalizer
  SCRIPT_PATH = Rails.root.join('scripts', 'ig.js').freeze

  option :script_path, optional: true, default: -> { SCRIPT_PATH }

  BASE_URL = 'https://instagram.com/p/'.freeze
  TIMESTAMP_PATH = ['taken_at_timestamp'].freeze
  CAPTION_PATH = ['edge_media_to_caption', 'edges', 0, 'node', 'text'].freeze
  IMAGE_URL_PATH = ['display_url'].freeze

  protected

  def link
    [BASE_URL, content['shortcode']].join
  end

  def published_at
    Time.at(content.dig(*TIMESTAMP_PATH)).to_datetime
  end

  def text
    [content, link].join(separator)
  end

  def content
    content.dig(*CAPTION_PATH)
  end

  # TODO: Move script interaction to a service class
  def attachments
    @attachments ||= fetch_image_urls
  end

  def fetch_image_urls
    command = "node #{script_path} post #{content['shortcode']}"
    logger.debug("fetching instagram image urls: #{command}")
    output = `#{command}`
    JSON.parse(output)
  end
end
