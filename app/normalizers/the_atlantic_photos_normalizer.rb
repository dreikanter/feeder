class TheAtlanticPhotosNormalizer < TumblrNormalizer
  def text
    [description, direct_link].compact_blank.join(separator)
  end

  # :reek:FeatureEnvy
  def direct_link
    link = content.link

    RestClient.get(link) do |response, _request, _result|
      redirecting = [301, 302, 307].include?(response.code)
      redirecting ? response.headers[:location] : link
    end
  end

  def attachments
    [image_url]
  end

  def comments
    [photo_description_excerpt]
  end

  private

  def description
    kill_newlines(Html.excerpt(content.description, length: limit))
  end

  MAX_EXPANDED_POST_LENGTH = 500

  def limit
    MAX_EXPANDED_POST_LENGTH - separator.length - link.length
  end

  def image_url
    Html.first_image_url(content.description)
  end

  def photo_description_excerpt
    kill_newlines(Html.comment_excerpt(photo_description))
  end

  def photo_description
    caption = Nokogiri::HTML(content.description).css("figure > figcaption")
    caption.try(:first).try(:text) || ""
  end

  def kill_newlines(text)
    text.to_s.gsub(/\s+/, " ")
  end
end
