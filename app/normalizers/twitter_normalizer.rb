class TwitterNormalizer < BaseNormalizer
  protected

  def validation_errors
    super.tap do |errors|
      errors << 'no images' if violates_no_images?
      errors << 'retweet' if violates_retweet?
      errors << 'bad structure' if violates_expected_structure?
    end
  end

  def link
    id = content.fetch('id')
    user_name = content.fetch('user').fetch('screen_name')
    "https://twitter.com/#{user_name}/status/#{id}"
  rescue KeyError
    nil
  end

  def published_at
    Time.parse(content.fetch('created_at'))
  rescue ArgumentError, KeyError
    nil
  end

  def text
    [tweet_text, "!#{link}"].join(separator)
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
    @images ||= content.dig('extended_entities', 'media') || []
  end

  def no_images?
    images.empty?
  end

  def retweet?
    content['retweeted_status'].present?
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

  def tweet_text
    content.fetch('text')
  rescue KeyError
    content.fetch('full_text')
  end
end
