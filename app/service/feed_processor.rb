module Service
  class FeedProcessor
    def self.for(feed_name, feeds = nil)
      send(:new, feed_name, feeds).send(:processor_class)
    end

    private

    attr_reader :feed_name
    attr_reader :feeds

    def initialize(feed_name, feeds = nil)
      @feed_name = feed_name.to_s
      @feeds = feeds
    end

    def processor_class
      best_match_for(Service::Feeds.find(feed_name, feeds))
    end

    def best_match_for(feed)
      available_names_for(feed).
        map { |n| processor_for(n) }.
        reject(&:nil?).first
    end

    def available_names_for(feed)
      [feed.name, feed.processor, :null].map { |n| n.to_s.gsub(/-/, '_') }
    end

    def processor_for(name)
      "feed_processors/#{name}_processor".classify.constantize
    rescue
      nil
    end
  end
end
