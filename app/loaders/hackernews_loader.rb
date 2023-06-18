class HackernewsLoader < BaseLoader
  def call
    load_story_ids.map { |id| load_story(id) }
  end

  private

  # TODO: Cache stories to load each 2h
  def load_story(id)
    load_json(Hackernews.item_url(id))
  end

  def load_story_ids
    load_json(Hackernews.best_stories_url)
  end

  def load_json(url)
    JSON.parse(HTTP.get(url).to_s)
  end
end
