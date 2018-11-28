class StatsController < ApplicationController
  def show
    @feeds = feeds
    @history = history
    @batches = DataPoint.for('batch').limit(10)
    @recent_posts = Post.includes(:feed).recent
  end

  private

  def feeds
    names = Service::FeedsList.call.map { |feed| feed['name'] }
    Feed.where(name: names).order(:updated_at)
  end

  def history
    posts = Post.where('created_at > ?', 30.days.ago).group('DATE(created_at)')
    posts.count.sort.to_h
  end
end
