class Pull
  include Callee

  param :feed
  option :logger, optional: true, default: -> { Rails.logger }
  option :loader, optional: true, default: -> { feed.loader_class }
  option :processor, optional: true, default: -> { feed.processor_class }
  option :normalizer, optional: true, default: -> { feed.normalizer_class }

  def call
    normalized_entities.reject(&:stale?)
  end

  private

  def normalized_entities
    new_entities.map { |entity| normalize_entity(entity) }.compact
  end

  # TODO: Optimize this
  def new_entities
    uids = entities.map(&:uid)
    existing_uids = Post.where(feed: feed, uid: uids).pluck(:uid)
    entities.filter { |entity| existing_uids.exclude?(entity.uid) }
  end

  def entities
    @entities ||= processor.call(content: content, feed: feed)
  end

  def content
    logger.info("---> loading feed (name: #{feed.name}; id: #{feed.id}; loader: #{feed.loader_class})")
    loader.call(feed, logger: logger)
  end

  def normalize_entity(entity)
    normalizer.call(entity)
  rescue StandardError => e
    ErrorDumper.call(
      exception: e,
      message: "Normalization error",
      target: feed,
      context: {uid: entity.uid}
    )

    nil
  end
end
