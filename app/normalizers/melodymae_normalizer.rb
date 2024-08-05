class MelodymaeNormalizer < WordpressNormalizer
  def attachments
    super.filter_map do |image_url|
      next if image_url.blank?
      image_url = original_url(image_url)
      next unless image_downloadable?(image_url)
      image_url
    end
  end

  private

  def original_url(url)
    url.sub(%r{https://i\d+\.wp\.com/}, "https://")
  end

  def image_downloadable?(url)
    response = HTTP.head(url)
    response.status.success?
  rescue StandardError
    false
  end
end
