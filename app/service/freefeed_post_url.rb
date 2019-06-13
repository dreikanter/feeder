module Service
  class FreefeedPostURL
    def self.call(feed_name, post_id)
      parts = [
        Rails.application.credentials.freefeed_base_url,
        feed_name,
        post_id
      ]

      parts.join('/')
    end
  end
end
