class PullJob < ApplicationJob
  before_perform do
    @started_at = Time.now.utc
    @posts_count = 0
    @errors_count = 0
  end

  after_perform do
    CreateDataPoint.call(
      :pull,
      feed_name: feed_name,
      posts_count: posts_count,
      errors_count: errors_count,
      duration: Time.new.utc - started_at,
      status: status
    )
  end

  def perform(feed)
    entities = Pull.call(feed)

    if entities.failure?
      error = entities.failure
      exception = error.is_a?(Exception) ? error : nil
      ErrorDumper.call(
        exception: exception,
        message: "error pulling feed [#{feed_name}]: #{error}",
        target: feed
      )
      return
    end

    entities.value!.each do |entity|
      if entity.failure?
        ErrorDumper.call(target: feed)
        count_error
        break
      end

      Post.create!(**entity.value!.merge(
        feed_id: feed.id,
        status: PostStatus.ready
      ))
      count_post
    end

    feed.posts.ready.each { |post| PushJob.perform_later(post) }
  ensure
    feed.update(
      last_post_created_at: feed.posts.maximum(:created_at),
      refreshed_at: started_at
    )
  end

  private

  attr_reader :errors_count, :posts_count, :started_at

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
