module Service
  class Feeds
    FEEDS_PATH = Rails.root.join('config', 'feeds.yml').freeze

    FEED_FIELDS = %w[
      name
      url
      processor
      normalizer
      after
    ].freeze

    DEFAULTS = FEED_FIELDS.map { |f| [f, nil] }.to_h.freeze

    def self.load(feeds)
      @feeds = sanitize_feeds(feeds)
    end

    def self.feeds
      @feeds ||= sanitize_feeds(YAML.load_file(FEEDS_PATH))
    end

    def self.count
      feeds.count
    end

    def self.sanitize_feeds(feeds)
      feeds.map { |f| OpenStruct.new(DEFAULTS.merge(f)) }
    end

    def self.find(name)
      feeds.find { |f| f.name == name.to_s }
    end

    def self.each
      feeds.each { |f| yield f }
    end

    def self.each_name(&block)
      feeds.each { |f| yield f.name }
    end
  end
end
