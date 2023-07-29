# Posts import flow:
#
# - Fetch and process feed entities with FeedEntitiesFetcher.
# - Normalize each new entity.
# - Save normalized data to Post records with draft state.
#
# Errors handling:
#
# - Feed loader and processor exceptions interrupt the flow.
# - Normalizer exception cause a feed entity to be ignored.
# - Normalizer exceptions are being reported, but not interrupt the flow.
#
class PostsImporter
  attr_reader :feed

  def initialize(feed)
    @feed = feed
  end

  def import
    feed.ensure_supported
    create_posts
  end

  private

  def create_posts
    new_feed_entities.each do |feed_entity|
      normalized_entity = normalize(feed_entity) or next
      update_post_status(post_for(normalized_entity))
    end
  end

  # Create new post or find an existing one
  # @return [Post]
  def post_for(normalized_entity)
    Post.transaction do
      Post.create_with(normalized_entity.to_h).find_or_create_by(feed: feed, uid: normalized_entity.uid)
    end
  end

  def update_post_status(post)
    return unless post.draft?
    post.validation_errors? ? post.reject! : post.enqueue!
  end

  def new_feed_entities
    feed_entities.filter { existing_uids.exclude?(_1.uid) }
  end

  def feed_entities
    @feed_entities ||= FeedEntitiesFetcher.new(feed).fetch
  end

  def existing_uids
    @existing_uids ||= Post.where(feed: feed, uid: feed_entities.map(&:uid)).pluck(:uid)
  end

  # @return [NormalizedEntity, nil]
  def normalize(feed_entity)
    normalizer.new(feed_entity).call
  rescue StandardError => e
    Honeybadger.notify(e)
    nil
  end

  def normalizer
    @normalizer ||= feed.normalizer_class
  end
end
