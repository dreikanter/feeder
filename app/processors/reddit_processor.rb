class RedditProcessor < AtomProcessor
  POINTS_THRESHOLD = 2000
  CACHE_HISTORY_DEPTH = 4.hours

  protected

  def entities
    super.select { |item| enough_points?(item.uid) }
  end

  private

  # TODO: Consider extrating Reddit score evaluation to a service
  # TODO: Use specialized model
  def enough_points?(link)
    reddit_points(link) >= POINTS_THRESHOLD
  end

  def reddit_points(link)
    data_point(link).details['points'].to_i
  rescue StandardError => e
    # NOTE: Individual post score fetching should not crash the processor
    # TODO: Improve RedditPointsFetcher errors tracking
    Honeybadger.notify(e)
    0
  end

  def data_point(link)
    cached_data_point(link) || create_data_point(link)
  end

  def cached_data_point(link)
    DataPoint.for(:reddit)
      .where('created_at > ?', CACHE_HISTORY_DEPTH.ago)
      .where("details->>'link' = ?", link).ordered.first
  end

  def create_data_point(link)
    CreateDataPoint.call(
      :reddit,
      link: link,
      points: RedditPointsFetcher.call(link)
    )
  end
end
