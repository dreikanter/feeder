class KotakuLoader < BaseLoader
  COMMENTS_COUNT_THRESHOLD = 100
  COMMENTS_COUNT_CACHE_TTL = 4.hours

  # @return [Array<Feedjira::Parser::RSSEntry>]
  def call
    yesterday_entries.sort_by { |entry| comments_count(entry.url) }.reverse.tap do |result|
      CreateDataPoint.call("kotaku", details: {"counters" => comment_counters.as_json.sort_by(&:second).reverse.to_h})
    end
  rescue StandardError => e
    # TODO: Remove this after the research
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

  def load_comments_count(url)
    html = load_url(url)
    element = Nokogiri::HTML(html).css("[data-replycount]").first
    Integer(element.attr("data-replycount"))
  end

  def yesterday_entries
    entries.filter { |entry| entry.published.yesterday? }
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
