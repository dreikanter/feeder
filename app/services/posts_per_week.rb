class PostsPerWeek
  include Callee

  HISTORY_DEPTH = 30
  DAYS_IN_A_WEEK = 7

  param :feed

  def call
    posts_count = recent_posts.count
    return 0 if posts_count.zero?
    posts_count.to_f / days_since_earliest_post * DAYS_IN_A_WEEK
  end

  private

  def recent_posts
    posts.where('published_at > ?', HISTORY_DEPTH.days.ago)
  end

  def posts
    feed.posts.published
  end

  def days_since_earliest_post
    earliest_post = recent_posts.order(published_at: :desc).last
    (DateTime.now.end_of_day - earliest_post.published_at.to_datetime).ceil
  end
end
