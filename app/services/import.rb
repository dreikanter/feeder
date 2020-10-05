class Import
  include Callee

  param :feed

  def call
    entities = Pull.call(feed)
    entities.each { |entity| persist_post(entity, feed: feed) }
    schedule_new_posts(feed)
  ensure
    feed.update(
      last_post_created_at: feed.posts.maximum(:created_at),
      refreshed_at: started_at
    )

    CreateDataPoint.call(
      :pull,
      feed_name: feed_name,
      posts_count: posts_count,
      errors_count: errors_count,
      duration: Time.new.utc - started_at,
      status: status
    )
  end

  private

  attr_reader :errors_count, :posts_count, :started_at

  def status
    return UpdateStatus.success if errors_count.zero?
    UpdateStatus.has_errors
  end

  def feed_name
    @feed_name ||= arguments.first.name
  end

  def schedule_new_posts(feed)
    feed.posts.queue.each { |post| PushJob.perform_later(post) }
  end

  def persist_post(entity, feed:)
    logger.info("new post; uid: #{entity[:uid]}")
    post = Post.find_by(feed_id: feed.id, uid: entity[:uid])
    post ||= Post.create!(entity.merge(feed_id: feed.id))
    post.update(status: post_status(entity))
  rescue StandardError => e
    post.update(status: PostStatus.error)
    Honeybadger.notify(e, error_message: "processing error: #{e}")
  end

  def post_status(entity)
    return PostStatus.ready if entity[:validation_errors].none?
    PostStatus.ignored
  end
end
