class HackernewsLoader < BaseLoader
  STORY_CACHE_TTL = 2.hours

  def call
    load_story_ids.map { |id| cached_story(id) }
  end

  private

  def cached_story(id)
    Rails.cache.fetch(story_cache_key(id), expires_in: STORY_CACHE_TTL) { load_story(id) }
  end

  def load_story(id)
    logger.info("---> loading hn story #{id}")
    load_json(Hackernews.item_url(id))
  end

  def story_cache_key(id)
    "#{self.class.name.underscore}:story:#{id}"
  end

  def load_story_ids
    load_json(Hackernews.best_stories_url)
  end

  def load_json(url)
    JSON.parse(HTTP.get(url).to_s)
  end
end
