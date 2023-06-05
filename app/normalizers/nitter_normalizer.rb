class NitterNormalizer < BaseNormalizer
  TWITTER_HOST = "twitter.com".freeze
  RETWEET_PREFIX = "RT by".freeze

  protected

  def link
    URI.parse(content.url).tap { _1.host = TWITTER_HOST }.to_s
  end

  def published_at
    content.published
  end

  def text
    [content.title, content.url].join(separator)
  end

  def attachments
    images
  end

  def validation_errors
    super.tap do |errors|
      errors << "no images" if violates_no_images?
      errors << "retweet" if violates_retweet?
    end
  end

  def violates_no_images?
    options["only_with_attachments"] && no_images?
  end

  def violates_retweet?
    options["ignore_retweets"] && retweet?
  end

  def images
    @images ||= Nokogiri::HTML(content.summary).css("img").map { _1[:src] }.compact
  end

  def no_images?
    images.empty?
  end

  def retweet?
    content.title.starts_with?(RETWEET_PREFIX)
  end
end
