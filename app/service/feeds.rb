module Service
  class Feeds
    include Enumerable

    FEEDS_PATH = Rails.root.join('config', 'feeds.yml').freeze

    def self.index
      send(:new)
    end

    def each
      return enum_for(:each) unless :block_given?
      @feeds.map { |f| OpenStruct.new f }.each { |f| yield f }
    end

    private

    def initialize
      @feeds = YAML.load_file(FEEDS_PATH)
      return @feeds if @feeds.kind_of? Enumerable
      raise "#{FEEDS_PATH} does not contain a list"
    end
  end
end
