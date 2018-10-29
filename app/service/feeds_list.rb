module Service
  class FeedsList
    def self.call
      @names ||= load_config(Rails.root.join('config', 'feeds.yml'))
    end

    def self.load_config(path)
      @names = YAML.load_file(path).map do |options|
        feed_name = options['name']
        raise 'each feeds should have a name' if feed_name.empty?
        feed_name
      end
    end
  end
end
