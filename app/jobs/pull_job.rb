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

  # TODO: Refactor this method
  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  def perform(feed)
    entities = Pull.call(feed)

    if entities.failure?
      error = entities.failure
      exception = error.is_a?(Exception) ? error : nil
      ErrorDumper.call(
        exception: exception,
        message: 'pull error',
        target: feed
      )
      return
    end

    # rubocop:disable Metrics/BlockLength
    entities.value!.each do |entity|
      if entity.failure?
        ErrorDumper.call(
          exception: entity.failure,
          message: 'normalization error',
          target: feed
        )
        count_error
        break
      end

      attributes = entity.value!
      valid = attributes[:validation_errors].none?
      # TODO: Replace PostStatus.ignored with non_valid
      post_status = valid ? PostStatus.ready : PostStatus.ignored

      logger.info("new post [#{post_status}]")
      post = Post.find_by(feed_id: feed.id, uid: attributes[:uid])
      post ||= Post.create!(attributes.merge(feed_id: feed.id))
      post.update(status: post_status)

      count_post
    end
    # rubocop:enable Metrics/BlockLength

    feed.posts.queue.each { |post| PushJob.perform_later(post) }
  rescue StandardError => e
    Honeybadger.notify(e)
    raise e
  ensure
    feed.update(
      last_post_created_at: feed.posts.maximum(:created_at),
      refreshed_at: started_at
    )
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

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
    @feed_name ||= arguments.first.name
  end
end
