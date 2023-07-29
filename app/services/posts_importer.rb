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
    new_feed_entities.each { create_post_from(_1) }
  end

  private

  # TODO: Set post state to rejected if validation_errors?

  def create_post_from(feed_entity)
    Post.create_with(normalize(feed_entity).to_h).find_or_create_by(feed: feed, uid: feed_enity.uid)
  rescue StandardError => e
    handle_normalizer_error(e)
  end

  def handle_normalizer_error(error)
    Honeybadger.notify(error)
  end

  def new_feed_entities
    feed_entities.filter { existing_uids.exclude?(_1["uid"]) }.lazy
  end

  def feed_entities
    @feed_entities ||= FeedEntitiesFetcher.new(feed).fetch
  end

  def existing_uids
    @existing_uids ||= Post.where(feed: feed, uid: feed_entities.map(&:uid))
  end

  # @return [NormalizedEntity]
  def normalize(feed_entity)
    normalizer.new(feed_entity).call
  end

  def normalizer
    @normalizer ||= feed.normalizer_class
  end
end
