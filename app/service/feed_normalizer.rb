module Service
  class FeedNormalizer
    def self.for(feed)
      send(:new, feed)
    end

    def process(entity)
      entity_attributes(entity).merge(common_attributes)
    end

    attr_reader :feed
    attr_reader :entity_normalizer

    private

    def initialize(feed)
      @feed = feed
      @entity_normalizer = Service::EntityNormalizer.for(feed)
    end

    def entity_attributes(entity)
      entity_normalizer.process(entity)
    end

    def common_attributes
      { 'feed_id' => feed.id, 'status' => 'ready' }
    end
  end
end
