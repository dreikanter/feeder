class StatsController < ApplicationController
  def show
    @feeds = Feed.all
    @history = history
  end

  private

  def history
    counters = {}
    DataPoint.for('pull').where('created_at > ?', 30.days.ago).each do |dp|
      key = dp.created_at.strftime("%Y/%m/%d")
      counters[key] ||= 0
      counters[key] += dp.details['posts_count'].to_i
    end
    counters
  end
end
