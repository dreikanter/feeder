module Service
  class EntityNormalizer
    def self.for(feed_name, feeds = nil)
      send(:new, feed_name, feeds).send(:normalizer_class)
    end

    private

    attr_reader :feed_name
    attr_reader :feeds

    def initialize(feed_name, feeds)
      @feed_name = feed_name
      @feeds = feeds
    end

    def normalizer_class
      best_match_for(Service::Feeds.find(feed_name, feeds)) ||
        raise("no matching normalizer for [#{feed.name}]")
    end

    def best_match_for(feed)
      available_names_for(feed).
        map { |n| normalizer_for(n) }.
        reject(&:nil?).first
    end

    def available_names_for(feed)
      [feed.name, feed.normalizer, feed.processor].
        map { |n| n.to_s.gsub(/-/, '_') }
    end

    def normalizer_for(name)
      "entity_normalizers/#{name}_normalizer".classify.constantize
    rescue
      nil
    end
  end
end
