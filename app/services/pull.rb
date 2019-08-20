class Pull
  include Callee
  include Dry::Monads[:result]
  include Dry::Monads[:do]

  param :feed
  option :logger, optional: true, default: -> { Rails.logger }
  option :loader, optional: true, default: -> { nil }
  option :processor, optional: true, default: -> { nil }
  option :normalizer, optional: true, default: -> { nil }

  Dry::Monads::Do.for(:call)

  # NOTE: Returns Result(Result[])
  def call
    content = yield loader_or_default.call(feed)
    entities = yield processor_or_default.call(content, feed)
    Success(normalize(entities))
  rescue StandardError => e
    Failure(e)
  end

  private

  def normalize(entities)
    new_entities(entities).map do |entity|
      normalizer_or_default.call(entity[0], entity[1], feed)
    end
  end

  def new_entities(entities)
    entities.filter do |uid|
      feed.posts.where(uid: uid).none?
    end
  end

  def loader_or_default
    loader || LoaderResolver.call(feed)
  end

  def processor_or_default
    processor || ProcessorResolver.call(feed)
  end

  def normalizer_or_default
    normalizer || NormalizerResolver.call(feed)
  end
end
