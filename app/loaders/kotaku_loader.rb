class KotakuLoader < BaseLoader
  include HttpClient

  COMMENTS_COUNT_THRESHOLD = 100
  COMMENTS_COUNT_CACHE_TTL = 4.hours

  # TODO: Remove tracking after the research
  # @return [Array<Feedjira::Parser::RSSEntry>]
  # :reek:TooManyStatements
  def content
    yesterday_entries.sort_by { |entry| comments_count(entry.url) }.reverse
  rescue StandardError => e
    Honeybadger.notify(e)
    []
  end

  private

  def comments_count(url)
    comment_counters[url] ||= KotakuCommentsCountLoader.new(url).comments_count
  end

  def comment_counters
    @comment_counters ||= {}
  end

  def yesterday_entries
    entries.filter { |entry| entry.published.yesterday? }
  end

  def entries
    @entries ||= Feedjira.parse(load_content).entries
  end

  def load_content
    http.get(feed.url).to_s
  end
end
