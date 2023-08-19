class OglafNormalizer < RssNormalizer
  def text
    [super, link].join(separator)
  end

  def attachments
    images.pluck(:src).compact
  end

  def comments
    titles.compact
  end

  def images
    @images ||= load_images
  end

  private

  def load_images
    log_info("#{self.class}: loading post images: #{link}")

    images = OglafCrowler.call(link).map do |page|
      page.css("img#strip:first").first
    end

    images.compact
  end

  def last_modified
    Time.zone.parse(response.headers[:last_modified])
  rescue StandardError
    Time.now.utc
  end

  def titles
    images.map do |image|
      Html.comment_excerpt(image[:title])
    end
  end
end
