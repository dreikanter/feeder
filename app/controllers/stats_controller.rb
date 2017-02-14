class StatsController < ApplicationController
  def show
    @feeds = Feed.all
    @history = recent_posts.group('DATE(created_at)').count.sort.to_h
  end

  private

  def recent_posts
    Post.where('created_at > ?', 30.days.ago)
  end
end
