class FreefeedFeedURL
  def self.call(feed_name)
    parts = [
      Rails.application.credentials.freefeed_base_url,
      feed_name
    ]

    parts.join("/")
  end
end
