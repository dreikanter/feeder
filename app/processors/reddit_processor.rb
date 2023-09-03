class RedditProcessor < BaseProcessor
  SCORE_THRESHOLD = 2000
  POST_SCORE_CACHE_TTL = 2.hours

  def process
    atom_feed_entries.select { above_score_threshold?(_1.uid) }
  end

  private

  def atom_feed_entries
    parsed_xml.xpath("/feed/entry").map do |entry|
      uid = entry.xpath("link").first.attributes["href"].value
      build_entity(uid, entry.to_xml)
    end
  end

  def parsed_xml
    Nokogiri::XML(content).tap { _1.remove_namespaces! }
  end

  def above_score_threshold?(url)
    cached_score(url) >= SCORE_THRESHOLD
  end

  def cached_score(url)
    Rails.cache.fetch(cache_key(url), expires_in: POST_SCORE_CACHE_TTL) { score(url) }
  end

  def score(url)
    RedditPointsFetcher.new(url).points
  rescue StandardError => e
    # NOTE: Individual post score fetching should not crash the processor,
    #  but they are getting reported to monitor Reddit availability
    Honeybadger.notify(e)
    0
  end

  def cache_key(url)
    [cache_key_prefix, url].join(":")
  end

  def cache_key_prefix
    @cache_key_prefix ||= self.class.name.underscore
  end
end
