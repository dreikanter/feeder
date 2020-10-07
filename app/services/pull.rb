class Pull
  include Callee

  param :feed
  option :logger, optional: true, default: -> { Rails.logger }
  option :loader, optional: true, default: -> { LoaderResolver.call(feed, logger: logger) }
  option :processor, optional: true, default: -> { ProcessorResolver.call(feed, logger: logger) }
  option :normalizer, optional: true, default: -> { NormalizerResolver.call(feed, logger: logger) }

  def call
    normalized_entities
  end

  private

  def normalized_entities
    new_entities.map { |entity| normalize_entity(entity, feed) }.compact
  end

  def new_entities
    uids = entities.map(&:uid)
    existing_uids = Post.where(feed: feed, uid: uids).pluck(:uid)
    entities.filter { |entity| !existing_uids.include?(entity.uid) }
  end

  def entities
    @entities ||= processor.call(content, feed, logger: logger)
  end

  def content
    loader.call(feed, logger: logger)
  end

  def normalize_entity(entity, feed)
    normalizer.call(entity.uid, entity.content, feed, logger: logger)
  rescue StandardError => e
    ErrorDumper.call(
      exception: e,
      message: 'Normalization error',
      target: feed,
      context: { uid: entity.uid }
    )

    nil
  end
end
