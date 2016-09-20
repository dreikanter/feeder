module Service
  class FeedProcessor
    def self.for(feed_name)
      feed = Service::Feeds.find(feed_name.to_s)
      [feed.name, feed.processor, :null].
        map { |n| n.to_s.gsub(/-/, '_') }.
        map { |n| processor_class(n) }.
        reject(&:nil?).first
    end

    def self.processor_class(name)
      "feed_processors/#{name}_processor".classify.constantize
    rescue
      nil
    end

    private_class_method :processor_class
  end
end
