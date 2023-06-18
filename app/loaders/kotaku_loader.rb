class KotakuLoader < BaseLoader
  COMMENTS_COUNT_THRESHOLD = 100
  COMMENTS_COUNT_CACHE_TTL = 4.hours

  def call
    entries_above_threshold.each do |entry|
      Post.create_with(
        published_at: entry.published || Time.current,
        link: entry.url,
        text: entry.title,
        status: PostStatus.ignored
      ).find_or_create_by(feed: feed, uid: entry.url)
    end

    # NOTE: Experimental loader
    nil
  end

  private

  def entries_above_threshold
    entries.filter { |entry| comments_count(entry.url) > COMMENTS_COUNT_THRESHOLD }
  end

  def comments_count(url)
    Rails.cache.fetch(cache_key(url), expires_in: COMMENTS_COUNT_CACHE_TTL) { load_comments_count(url) }
  end

  def cache_key(url)
    "#{self.class.name.underscore}:comments_count:#{url}"
  end

  def load_comments_count(url)
    html = load_url(url)
    element = Nokogiri::HTML(html).css("[data-replycount]").first
    Integer(element.attr("data-replycount"))
  rescue StandardError => e
    # TODO: Remove this after the research
    Honeybadger.notify(e)
    0
  end

  def entries
    @entries ||= Feedjira.parse(content).entries
  end

  def content
    load_url(feed.url)
  end

  def load_url(url)
    HTTP.get(url).to_s
  end
end
