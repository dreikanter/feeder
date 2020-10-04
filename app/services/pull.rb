class Pull
  include Callee

  param :feed
  option :logger, optional: true, default: -> { Rails.logger }
  option :loader, optional: true, default: -> { LoaderResolver.call(feed) }
  option :processor, optional: true, default: -> { ProcessorResolver.call(feed) }
  option :normalizer, optional: true, default: -> { NormalizerResolver.call(feed) }

  def call
    new_entities.map do |entity|
      normalizer.call(entity.uid, entity.content, feed)
    end
  end

  private

  def new_entities
    uids = entities.map(&:uid)
    existing_uids = Post.where(feed: feed, uid: uids).pluck(:uid)
    entities.select { |entity| existing_uids.exclude?(entity.uid) }
  end

  def entities
    processor.call(content, feed)
  end

  def content
    loader.call(feed)
  end
end
