class Hackernews
  BASE_URL = "https://news.ycombinator.com".freeze
  BASE_API_URL = "https://hacker-news.firebaseio.com".freeze

  class << self
    def best_stories_url
      base_api_url.merge("/v0/beststories.json").to_s
    end

    def thread_url(id)
      base_url.merge("/item?id=#{id}").to_s
    end

    def item_url(id)
      base_api_url.merge("/v0/item/#{id}.json").to_s
    end

    private

    def base_url
      @base_url ||= URI.parse(BASE_URL)
    end

    def base_api_url
      @base_api_url ||= URI.parse(BASE_API_URL)
    end
  end
end
