class ProcessFeed
  include Callee

  param :feed
  option :logger, optional: true, default: -> { Rails.logger }

  def call
    Honeybadger.context(process_feed: {feed_id: feed_id, feed_name: feed_name})
    generate_new_posts
  end

  private

  def generate_new_posts
    feed.touch(:refreshed_at)
    logger.info("---> new posts: #{normalized_entities_count}; errors: #{errors_count}")
    normalized_entities.each { |normalized_entity| push(normalized_entity) }
    feed.update(errors_count: 0)
    feed.update_sparkline
  rescue StandardError => e
    increment_feed_error_counters
    dump_feed_error(e)
  end

  def push(normalized_entity)
    return unless normalized_entity
    logger.info("---> creating post; uid: [#{normalized_entity.uid}]")
    post = normalized_entity.find_or_create_post
    update_last_post_created_at
    return unless post.ready?
    logger.info("---> publishing post; uid: [#{post.uid}]")
    Push.call(post)
  end

  def feed_id
    feed.id
  end

  def feed_name
    feed.name
  end

  def normalized_entities_count
    normalized_entities.count
  end

  def errors_count
    normalized_entities.count do |entity|
      entity.status != PostStatus.ready
    end
  end

  def normalized_entities
    @normalized_entities ||= Pull.call(feed)
  end

  def update_last_post_created_at
    feed.update(last_post_created_at: feed.posts.maximum(:created_at))
  end

  def increment_feed_error_counters
    feed.update(
      errors_count: feed.errors_count.succ,
      total_errors_count: feed.total_errors_count.succ
    )
  end

  def dump_feed_error(error)
    ErrorDumper.call(
      exception: error,
      message: "Error processing feed",
      target: feed,
      context: {feed_name: feed_name}
    )
  end
end
