class RedditProcessor < AtomProcessor
  SCORE_THRESHOLD = 2000
  POST_SCORE_CACHE_TTL = 4.hours

  protected

  def entities
    super.select { |item| above_score_threshold?(item.uid) }
  end

  private

  def above_score_threshold?(link)
    cached_score(link) >= SCORE_THRESHOLD
  end

  def cached_score(link)
    Rails.cache.fetch(cache_key(link), expires_in: POST_SCORE_CACHE_TTL) { score(link) }
  end

  def score(link)
    RedditPointsFetcher.call(link)
  rescue StandardError => e
    # NOTE: Individual post score fetching should not crash the processor,
    #  but they are getting reported to monitor Reddit availability
    Honeybadger.notify(e)
    0
  end

  def cache_key(link)
    [cache_key_prefix, link].join(":")
  end

  def cache_key_prefix
    @cache_key_prefix ||= self.class.name.underscore
  end
end
