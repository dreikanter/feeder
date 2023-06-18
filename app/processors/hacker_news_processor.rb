class HackerNewsProcessor < BaseProcessor
  protected

  def entities
    load_data.map { |id| build_entity(id) }
  end

  def build_entity(id)
    link = Hackernews.thread_url(id)
    content = {id: id, link: link, data_url: Hackernews.item_url(id)}
    entity(link, content)
  end

  def load_data
    JSON.parse(RestClient.get(best_stories_url).body)
  end
end
