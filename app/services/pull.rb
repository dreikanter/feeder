class Pull
  include Callee
  include Logging

  param :feed

  def call
    normalized_entities.reject(&:stale?)
  end

  private

  delegate :loader_class, :processor_class, :normalizer_class, to: :feed

  def normalized_entities
    new_entities.map { normalize_entity(_1) }.compact
  end

  def new_entities
    entities.filter { existing_uids.exclude?(_1.uid) }
  end

  def existing_uids
    @existing_uids ||= Post.where(feed: feed, uid: entities.map(&:uid)).pluck(:uid)
  end

  def entities
    @entities ||= processor_class.call(content: content, feed: feed)
  end

  def content
    logger.info("---> loading feed (name: #{feed.name}; id: #{feed.id}; loader: #{loader_class})")
    loader_class.call(feed, logger: logger)
  end

  def normalize_entity(entity)
    normalizer_class.call(entity)
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
