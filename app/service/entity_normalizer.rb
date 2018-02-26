module Service
  class EntityNormalizer
    def self.for(feed)
      send(:new, feed).send(:normalizer_class)
    end

    private

    attr_reader :feed

    def initialize(feed)
      @feed = feed
    end

    def normalizer_class
      matching_normalizer || raise("no matching normalizer for [#{feed.name}]")
    end

    def matching_normalizer
      available_names.each { |n| return normalizer_for(n) rescue next }
    end

    def available_names
      [ feed.name, feed.normalizer, feed.processor ].
        map { |n| n.to_s.gsub(/-/, '_') }.lazy
    end

    def normalizer_for(name)
      "normalizers/#{name}_normalizer".classify.constantize
    end
  end
end
