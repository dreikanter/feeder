class Import
  include Callee

  param :feed

  def call
    @started_at = Time.now.utc
    generate_new_posts
  ensure
    update_feed_timestamps
    save_data_point
  end

  private

  attr_reader :started_at

  def generate_new_posts
    entities.each do |entity|
      next unless entity
      logger.info("new post; #{entity[:uid]}")
      post = find_or_create_new_post(entity)
      post.update(status: post_status(entity))
      PushJob.perform_later(post) if post.ready?
    end
  end

  def find_or_create_new_post(entity)
    existing_post = Post.find_by(feed_id: feed_id, uid: entity[:uid])
    existing_post || Post.create!(entity.merge(feed_id: feed_id))
  end

  def feed_id
    feed.id
  end

  def post_status(entity)
    entity[:validation_errors].none? ? PostStatus.ready : PostStatus.ignored
  end

  # TODO: Bypass normalization errors in the entities list, update errors_count
  def save_data_point
    CreateDataPoint.call(
      :pull,
      feed_name: feed.name,
      posts_count: entities.count,
      errors_count: 0,
      duration: Time.new.utc - started_at,
      status: UpdateStatus.success
    )
  end

  def entities
    @entities ||= Pull.call(feed)
  end

  def update_feed_timestamps
    feed.update(
      last_post_created_at: last_post_created_at,
      refreshed_at: started_at
    )
  end

  def last_post_created_at
    feed.posts.maximum(:created_at)
  end
end
