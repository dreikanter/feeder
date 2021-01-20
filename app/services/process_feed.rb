class ProcessFeed
  include Callee

  param :feed
  option :logger, optional: true, default: -> { Rails.logger }

  def call
    Honeybadger.context(feed_id: feed.try(:id), feed_name: feed.try(:name))
    @started_at = Time.current
    generate_new_posts
    create_data_point
  end

  private

  attr_reader :started_at

  def generate_new_posts
    logger.info("---> new posts: #{normalized_entities_count}; errors: #{errors_count}")

    normalized_entities.each do |normalized_entity|
      next unless normalized_entity
      logger.info("---> creating post; uid: [#{normalized_entity.uid}]")
      post = normalized_entity.find_or_create_post
      update_feed_timestamps
      next unless post.ready?
      logger.info("---> publishing post; uid: [#{post.uid}]")
      Push.call(post)
    end
  end

  def feed_id
    feed.id
  end

  def feed_name
    feed.name
  end

  # TODO: Create data point with error status on error
  def create_data_point
    logger.info("---> updating feed history [#{feed_name}]")

    CreateDataPoint.call(
      :pull,
      feed_name: feed_name,
      posts_count: normalized_entities_count,
      errors_count: errors_count,
      duration: Time.current - started_at,
      status: UpdateStatus.success
    )
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

  def update_feed_timestamps
    logger.info("---> updating feed timestamps [#{feed_name}]")

    feed.update(
      last_post_created_at: last_post_created_at,
      refreshed_at: started_at
    )
  end

  def last_post_created_at
    feed.posts.maximum(:created_at)
  end
end
