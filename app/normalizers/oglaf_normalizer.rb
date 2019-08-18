class OglafNormalizer < RssNormalizer
  protected

  def text
    [super, link].join(separator)
  end

  def published_at
    @published_at ||= last_modified
  end

  def attachments
    images.map { |image| image[:src] }.compact
  end

  def comments
    titles.compact
  end

  private

  def images
    @images ||= load_images
  end

  def load_images
    OglafCrowler.call(link).map do |page|
      page.css('img#strip:first').first
    end
  end

  def last_modified
    Time.parse(response.headers[:last_modified])
  rescue
    Time.now.utc
  end

  def titles
    images.map do |image|
      Html.comment_excerpt(image[:title])
    end
  end
end
