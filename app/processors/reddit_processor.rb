class RedditProcessor < AtomProcessor
  POINTS_THRESHOLD = 2000
  CACHE_HISTORY_DEPTH = 4.hours

  protected

  def entities
    super.select { |item| enough_points?(item.uid) }
  end

  private

  def enough_points?(link)
    reddit_points(link) >= POINTS_THRESHOLD
  end

  def reddit_points(link)
    data_point(link).details['points'].to_i
  end

  def data_point(link)
    cached_data_point(link) || create_data_point(link)
  end

  def cached_data_point(link)
    logger.debug('attempting to load reddit points from cache')
    DataPoint.for(:reddit)
      .where('created_at > ?', CACHE_HISTORY_DEPTH.ago)
      .where("details->>'link' = ?", link).ordered.first
  end

  def create_data_point(link)
    logger.debug('loading reddit points from reddit')

    CreateDataPoint.call(
      :reddit,
      link: link,
      points: RedditPointsFetcher.call(link),
      description: desc
    )
  end
end
