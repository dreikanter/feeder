# Posts import flow:
#
# - Fetch and process feed entities with FeedEntitiesFetcher.
# - Normalize each new entity.
# - Save normalized data to Post records with draft state.
#
# Errors handling:
#
# - Feed loader and processor exceptions interrupt the flow.
# - Normalizer exceptions cause problematic feed entities to be ignored.
# - Normalizer exceptions are reported.
#
class PostsImporter
  attr_reader :feed

  def initialize(feed)
    @feed = feed
  end

  def import
    new_feed_entities.each { create_post_from(_1) }
  end

  private

  def create_post_from(feed_entity)
    Post.create_with(normalize(feed_entity).to_h).find_or_create_by(feed: feed, uid: feed_enity.uid))
  rescue StandardError => e
    Honeybadger.notify(e)
  end

  def new_feed_entities
    @new_feed_entities ||= feed_entities.filter { existing_uids.exclude?(_1["uid"]) }.map.lazy { normalize(_1) }
  end

  def feed_entities
    @feed_entities ||= FeedEntitiesFetcher.new(feed).fetch
  end

  def existing_uids
    @existing_uids ||= Post.where(feed: feed, uid: feed_entities.map(&:uid))
  end

  # @return [NormalizedEntity]
  def normalize(feed_entity)
    feed.normalize_class.new(feed_entity).call
  end
end
