class KotakuLoader < BaseLoader
  COMMENTS_COUNT_THRESHOLD = 100
  COMMENTS_COUNT_CACHE_TTL = 4.hours

  # TODO: Remove tracking after the research
  # @return [Array<Feedjira::Parser::RSSEntry>]
  # :reek:TooManyStatements
  def call
    yesterday_entries.sort_by { |entry| comments_count(entry.url) }.reverse
  rescue StandardError => e
    Honeybadger.notify(e)
    []
  end

  private

  def comments_count(url)
    comment_counters[url] ||= load_comments_count(url)
  end

  def comment_counters
    @comment_counters ||= {}
  end

  def yesterday_entries
    entries.filter { |entry| entry.published.yesterday? }
  end

  def entries
    @entries ||= Feedjira.parse(content).entries
  end

  def content
    HTTP.get(feed.url).to_s
  end

  def comments_count(post_url)
    KotakuCommentsCountLoader.new(post_url).comments_count
  end
end
