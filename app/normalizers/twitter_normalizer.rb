module Normalizers
  class TwitterNormalizer < Normalizers::Base
    def valid?
      !(violates_no_images? && violates_retweet?)
    end

    def validation_errors
      Array.new.tap do |errors|
        errors << 'no images' if violates_no_images?
        errors << 'retweet' if violates_retweet?
      end
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

    def attachments
      images.map { |image| image['media_url_https'] }.reject(&:blank?)
    end

    private

    def entity_id
      entity.fetch('id')
    end

    def user_name
      entity.fetch('user').fetch('screen_name')
    end

    def images
      @images ||= entity.dig('extended_entities', 'media') || []
    end

    def no_images?
      images.empty?
    end

    def retweet?
      entity['retweeted_status'].present?
    end

    def violates_no_images?
      options['only_with_attachments'] && no_images?
    end

    def violates_retweet?
      options['ignore_retweets'] && retweet?
    end
  end
end
