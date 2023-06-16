class SparklineBuilder
  attr_reader :feed, :start_date, :end_date

  def initialize(feed, start_date:, end_date:)
    @feed = feed
    @start_date = start_date
    @end_date = end_date
  end

  def create_or_update
    Sparkline.find_or_create_by(feed: feed).tap do |sparkline|
      sparkline.update!(data: {points: points})
    end
  end

  private

  def points
    SparklineChart.new(timeline).generate
  end

  # TODO: Optimize with grouping by date
  def timeline
    dates.to_h { |date| [date, posts_count_at(date)] }
  end

  def posts_count_at(date)
    Post.where(feed: feed, created_at: date.all_day).count
  end

  def dates
    start_date.to_date..end_date.to_date
  end
end