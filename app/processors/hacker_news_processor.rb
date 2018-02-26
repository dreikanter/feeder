module Processors
  class HackerNewsProcessor < Processors::Base
    BASE_URL = 'https://news.ycombinator.com'.freeze
    BASE_API_URL = 'https://hacker-news.firebaseio.com/v0'.freeze

    def entities
      JSON.parse(RestClient.get(best_stories_url).body).map do |id|
        link = thread_url(id)
        [link, { id: id, link: link, data_url: item_url(id) }]
      end
    end

    def limit
      100
    end

    def thread_url(id)
      "#{BASE_URL}/item?id=#{id}"
    end

    def best_stories_url
      "#{BASE_API_URL}/beststories.json"
    end

    def item_url(id)
      "#{BASE_API_URL}/item/#{id}.json"
    end
  end
end
