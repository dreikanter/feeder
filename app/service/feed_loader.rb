module Service
  class FeedLoader
    def self.load(feed_name)
      send(:new, feed_name).send(:load)
    end

    private

    attr_reader :feed_info

    def initialize(feed_name)
      @feed_info = Service::Feeds.index.find { |f| f.name == feed_name.to_s }
      fail ArgumentError, "unknown feed name: #{feed_name}" unless @feed_info
    end

    def feed_content
      re = RestClient.get(feed_info.url)
      return re.body if re.code == 200
      fail "error loading feed: #{feed_info.url}"
    end

    def feed
      @feed ||= Feed.find_or_create_by(name: feed_info.name)
    end

    def load
      refreshed_at = Time.zone.now
      processed_entities
    rescue
      refreshed_at = nil
      raise
    ensure
      feed.update(refreshed_at: refreshed_at) if refreshed_at
    end

    def processed_entities
      processor.process(feed_content).map { |e| create_post(e) }.
        reject(&:nil?).sort { |a, b| a.published_at <=> b.published_at }
    end

    def processor
      Service::Processor.for(feed_info.processor || feed_info.name)
    end

    def create_post(entity)
      return if Post.where(feed: feed, link: entity['link']).exists?
      Rails.logger.info 'creating new post'
      Post.create!(postprocessor.process(entity).merge(feed: feed))
    rescue => e
      Rails.logger.error "error processing feed entity: #{e.message}"
    end

    def postprocessor
      @postprocessor ||= Service::Postprocessor.for(feed_info.name)
    end
  end
end
