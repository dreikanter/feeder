class PullJob < ApplicationJob
  before_perform :intro
  after_perform :outro

  def perform(feed)
    feed.update(refreshed_at: nil)
    Pull.call(feed).each do |entity|
      if entity.failure?
        count_error
        next
      end

      post_attributes = entity.value!.symbolize_keys.merge(
        feed_id: feed.id,
        status: PostStatus.ready
      )

      post = Post.create!(**post_attributes)
      PushJob.perform_later(post)
      count_post
    end

    last_post_created_at =
      feed.posts.order(created_at: :desc).first.try(:created_at)

    feed.update(
      last_post_created_at: last_post_created_at,
      refreshed_at: started_at
    )
  end

  private

  attr_reader :errors_count, :posts_count, :started_at

  def intro
    @started_at = Time.now.utc
    @posts_count = 0
    @errors_count = 0
  end

  def outro
    CreateDataPoint.call(
      :pull,
      feed_name: feed_name,
      posts_count: posts_count,
      errors_count: errors_count,
      duration: Time.new.utc - started_at,
      status: status
    )
  end

  def status
    return UpdateStatus.success if errors_count.zero?
    UpdateStatus.has_errors
  end

  def count_post
    @posts_count += 1
  end

  def count_error
    @errors_count += 1
  end

  def feed_name
    arguments[0].name
  end
end
