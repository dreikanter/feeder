class ProcessFeed
  include Logging

  attr_reader :feed

  def initialize(feed)
    @feed = feed
  end

  def process
    Honeybadger.context(process_feed: {feed_id: feed_id, feed_name: feed_name})
    generate_new_posts
  ensure
    feed.update_sparkline
  end

  private

  # :reek:TooManyStatements
  def generate_new_posts
    feed.touch(:refreshed_at)
    normalized_entities.reverse_each { |normalized_entity| push(normalized_entity) }
    feed.update(errors_count: 0)
  rescue StandardError => e
    increment_feed_error_counters
    dump_feed_error(e)
  end

  # :reek:TooManyStatements
  def push(normalized_entity)
    return unless normalized_entity
    log_info("---> creating post; uid: [#{normalized_entity.uid}]")
    post = normalized_entity.find_or_create_post
    return post.reject! if post.validation_errors?
    # TODO: Update post state
    # post.enqueue!
    update_last_post_created_at
    Push.call(post)
  end

  def feed_id
    feed.id
  end

  def feed_name
    feed.name
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
