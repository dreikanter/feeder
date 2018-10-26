module Service
  class FeedsList
    CONFIG_PATH = Rails.root.join('config', 'feeds.yml').freeze

    def self.call
      @names ||= load_config
    end

    def self.load_config(path = CONFIG_PATH)
      @names = YAML.load_file(path).map do |options|
        feed_name = options['name']
        raise 'each feeds should have a name' if feed_name.empty?
        feed_name
      end
    end
  end
end
