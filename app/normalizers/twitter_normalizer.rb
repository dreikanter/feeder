class TwitterNormalizer < BaseNormalizer
  protected

  def validation_errors
    Array.new.tap do |errors|
      errors << 'no images' if violates_no_images?
      errors << 'retweet' if violates_retweet?
      errors << 'bad structure' if violates_expected_structure?
    end
  end

  def link
    entity_id = entity.fetch('id')
    user_name = entity.fetch('user').fetch('screen_name')
    "https://twitter.com/#{user_name}/status/#{entity_id}"
  rescue KeyError
    nil
  end

  def published_at
    Time.parse(entity.fetch('created_at'))
  rescue ArgumentError, KeyError
    nil
  end

  def text
    [entity.fetch('text'), "!#{link}"].join(separator)
  rescue KeyError
    nil
  end

  def attachments
    images.map { |image| image.fetch('media_url_https') }.reject(&:blank?)
  rescue KeyError
    nil
  end

  private

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

  def violates_expected_structure?
    !link || !published_at || !text || !attachments
  end
end
