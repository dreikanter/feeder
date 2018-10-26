module Service
  class FeedsRepository
    CONFIG_PATH = Rails.root.join('config', 'feeds.yml').freeze

    def self.feeds
      @feeds ||= load_config
    end

    def self.load_config(path = CONFIG_PATH)
      @feeds = YAML.load_file(path).map do |options|
        feed_name = options['name']
        raise 'each feeds should have a name' if feed_name.empty?
        feed = Feed.find_or_create_by(name: feed_name)
        feed.update(options)
        feed
      end
    end

    def self.find(name)
      feeds.find { |feed| feed.name == name }
    end

    def self.each
      feeds.each { |feed| yield feed }
    end
  end
end
