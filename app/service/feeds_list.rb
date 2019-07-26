module Service
  class FeedsList
    DEFAULTS = {
      'after' => nil,
      'import_limit' => nil,
      'loader' => nil,
      'normalizer' => nil,
      'options' => {},
      'processor' => nil,
      'refresh_interval' => 0,
      'url' => nil
    }.freeze

    DEFAULT_PATH = Rails.root.join('config', 'feeds.yml')

    def self.call(path = DEFAULT_PATH)
      YAML.load_file(path).map do |options|
        raise 'each feed should have a name' if options['name'].empty?
        DEFAULTS.merge(options)
      end
    end

    def self.names
      call.map { |feed| feed['name'] }
    end
  end
end
