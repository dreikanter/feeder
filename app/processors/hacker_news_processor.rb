class HackerNewsProcessor < BaseProcessor
  BASE_URL = 'https://news.ycombinator.com'.freeze
  BASE_API_URL = 'https://hacker-news.firebaseio.com/v0'.freeze

  protected

  def entities
    load_data.map { |id| build_entity(id) }
  end

  def build_entity(id)
    link = thread_url(id)
    content = { id: id, link: link, data_url: item_url(id) }
    entity(link, content)
  end

  def load_data
    JSON.parse(RestClient.get(best_stories_url).body)
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
