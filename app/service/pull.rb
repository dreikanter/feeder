module Service
  class Pull
    include Callee

    param :feed
    param :batch, default: -> { nil }
    option :on_error, optional: true, default: -> { nil }
    option :logger, optional: true, default: -> { Rails.logger }

    def call
      logger.info("---> loading feed: #{feed_name}")

      # TODO: Handle errors
      content = loader.call(feed)
      entities = processor.call(content, feed)

      entities
        .filter(&post_exists?)
        .map(&normalize)
        .filter(&normalization_failed?)
        .map(&extract_payload)
        .filter(&fresh?)
        .map { |post| yield(post) }
    end

    private

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

    def post_exists?
      ->(uid, _entity) { Post.where(feed: feed, uid: uid).none? }
    end

    def normalize
      ->(uid, entity) { [uid, normalizer.call(entity, feed)] }
    end

    def normalization_failed?
      ->(_uid, normalized_entity) { normalized_entity.success? }
    end

    def extract_payload
      ->(uid, normalized_entity) { [uid, normalized_entity.payload] }
    end

    def fresh?
      proc do |_uid, payload|
        published_at = payload['published_at']
        after = feed.after
        !after || !published_at || (published_at > after)
      end
    end
  end
end
