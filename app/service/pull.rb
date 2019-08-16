module Service
  class Pull
    include Callee
    include Dry::Monads[:result]

    param :feed
    option :logger, optional: true, default: -> { Rails.logger }

    def call
      fresh_entities.sort_by { |item| item.value!['published_at'] }
    end

    private

    def fresh_entities
      after = feed.after
      return entities unless after
      entities.filter do |entity|
        published_at = entity.value_or({})['published_at']
        !published_at || (published_at > after)
      end
    end

    def entities
      loader.call(feed)
        .bind { |content| processor.call(content, feed) }
        .bind { |entities| entities.filter(&not_imported_yet?) }
        .map { |entity| normalizer.call(entity[0], entity[1], feed) }
    end

    def not_imported_yet?
      proc do |uid, _entity|
        Post.where(feed: feed, uid: uid).none?
      end
    end

    def feed_name
      feed.name
    end

    def loader
      @loader ||= Service::LoaderResolver.call(feed)
    end

    def processor
      @processor ||= Service::ProcessorResolver.call(feed)
    end

    def normalizer
      @normalizer ||= Service::NormalizerResolver.call(feed)
    end
  end
end
