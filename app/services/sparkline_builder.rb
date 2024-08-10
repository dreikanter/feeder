class SparklineBuilder
  include Logging

  attr_reader :feed, :start_date, :end_date

  def initialize(feed, start_date:, end_date:)
    @feed = feed
    @start_date = start_date
    @end_date = end_date
  end

  def create_or_update
    log_info("#{self.class}: building sparkline for [#{feed.name}] feed")

    Sparkline.find_or_create_by(feed: feed).tap do |sparkline|
      sparkline.update!(data: {points: points})
    end
  end

  private

  def points
    SparklineChart.new(timeline).generate
  end

  def timeline
    dates.index_with { posts_count_by_date[_1] || 0 }
  end

  def posts_count_by_date
    @posts_count_by_date ||= Post.where(feed: feed, created_at: period).group("DATE(created_at)").count
  end

  def dates
    (start_date.to_date..end_date.to_date).to_a
  end

  def period
    start_date.beginning_of_day..end_date.end_of_day
  end
end
