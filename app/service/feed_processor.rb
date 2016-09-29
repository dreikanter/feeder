module Service
  class FeedProcessor
    def self.for(feed_name)
      send(:new, feed_name).send(:processor_class)
    end

    private

    attr_reader :feed

    def initialize(feed_name)
      @feed = Feed.find_by_name!(feed_name.to_s)
    end

    def processor_class
      matching_processor || raise('no matching processor found')
    end

    def matching_processor
      available_names_for.each { |n| return processor_for(n) rescue next }
    end

    def available_names_for
      [feed.name, feed.processor, :null].map { |n| n.to_s.gsub(/-/, '_') }.lazy
    end

    def processor_for(name)
      "feed_processors/#{name}_processor".classify.constantize
    end
  end
end
