module Service
  class FeedsList
    def self.call
      @feeds ||= load_config(Rails.root.join('config', 'feeds.yml'))
    end

    def self.names
      call.map { |feed| feed['name'] }
    end

    def self.load_config(path)
      @feeds = YAML.load_file(path).map do |options|
        raise 'each feeds should have a name' if options['name'].empty?
        options
      end
    end
  end
end
