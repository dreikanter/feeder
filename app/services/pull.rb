class Pull
  include Callee

  param :feed

  def call
    normalized_entities.reject(&:stale?)
  end

  private

  delegate :loader_class, :processor_class, :normalizer_class, to: :feed

  def normalized_entities
    new_entities.filter_map { normalize_entity(_1) }
  end

  def new_entities
    entities.filter { existing_uids.exclude?(_1.uid) }
  end

  def existing_uids
    @existing_uids ||= Post.where(feed: feed, uid: entities.map(&:uid)).pluck(:uid)
  end

  def entities
    @entities ||= processor_class.call(content: loader_class.new(feed).content, feed: feed)
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
