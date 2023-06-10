class NitterNormalizer < BaseNormalizer
  RETWEET_PREFIX = 'RT by'.freeze

  protected

  def link
    NitterPermalink.call(content.url)
  end

  def published_at
    content.published
  end

  def text
    [content.title, "!#{link}"].join(separator)
  end

  def attachments
    images
  end

  def validation_errors
    super.tap do |errors|
      errors << 'no images' if violates_no_images?
      errors << 'retweet' if violates_retweet?
    end
  end

  def violates_no_images?
    options['only_with_attachments'] && no_images?
  end

  def violates_retweet?
    options['ignore_retweets'] && retweet?
  end

  def images
    @images ||= Nokogiri::HTML(content.summary).css('img').pluck(:src).compact
  end

  def no_images?
    images.empty?
  end

  def retweet?
    content.title.starts_with?(RETWEET_PREFIX)
  end
end
