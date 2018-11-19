class StatsController < ApplicationController
  def show
    names = Service::FeedsList.call.map { |feed| feed['name'] }
    @feeds = Feed.where(name: names).order(:updated_at)
    @history = recent_posts.group('DATE(created_at)').count.sort.to_h
  end

  private

  def recent_posts
    Post.where('created_at > ?', 30.days.ago)
  end
end
