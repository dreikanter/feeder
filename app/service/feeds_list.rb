module Service
  class FeedsList
    DEFAULT_PATH = Rails.root.join('config', 'feeds.yml')

    def self.call(path = DEFAULT_PATH)
      feeds = YAML.load_file(path)
      raise 'feeds configuration should define a list' unless feeds.is_a?(Array)
      feeds.map { |feed| Service::FeedSanitizer.call(feed.symbolize_keys) }
    end

    def self.names
      call.map { |feed| feed[:name] }
    end

    def self.[](feed_name)
      call.find { |feed| feed[:name] == feed_name }
    end
  end
end
