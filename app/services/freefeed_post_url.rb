class FreefeedPostURL
  def self.call(feed_name, post_id)
    parts = [
      FreefeedClientBuilder.base_url,
      feed_name,
      post_id
    ]

    parts.join("/")
  end
end
