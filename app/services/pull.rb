class Pull
  include Callee

  param :feed
  option :logger, optional: true, default: -> { Rails.logger }
  option :loader, optional: true, default: -> { LoaderResolver.call(feed) }
  option :processor, optional: true, default: -> { ProcessorResolver.call(feed) }
  option :normalizer, optional: true, default: -> { NormalizerResolver.call(feed) }

  def call
    normalize(entities)
  end

  private

  def normalize(entities)
    new_entities(entities).map { |entity| normalize_entity(entity, feed) }.compact
  end

  def new_entities(entities)
    uids = entities.map(&:uid)
    existing_uids = Post.where(feed: feed, uid: uids).pluck(:uid)
    entities.filter { |entity| !existing_uids.include?(entity.uid) }
  end

  def entities
    processor.call(content, feed, logger: logger)
  end

  def content
    loader.call(feed, logger: logger)
  end

  def normalize_entity(entity, feed)
    normalizer.call(entity.uid, entity.content, feed, logger: logger)
  rescue StandardError => e
    Honeybadger.notify(e, error_message: "normalization error: #{e.message}")
    nil
  end
end
