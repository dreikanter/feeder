module Service
  class FeedLoader
    def self.load(feed_name)
      send(:new, feed_name).send(:load)
    end

    private

    attr_reader :feed_info

    def initialize(feed_name)
      @feed_info = Service::Feeds.find(feed_name.to_s)
      fail ArgumentError, "unknown feed name: #{feed_name}" unless @feed_info
    end

    def load
      refreshed_at = Time.zone.now
      return processed_entities
    rescue
      refreshed_at = nil
      raise
    ensure
      feed.update(refreshed_at: refreshed_at) if refreshed_at
    end

    def feed
      @feed ||= Feed.find_or_create_by(name: feed_info.name)
    end

    def processed_entities
      new_entities.
        map { |e| normalizer.process(e) }.
        map { |e| create_post(e) }.
        reject(&:nil?).
        sort { |a, b| a.published_at <=> b.published_at }
    end

    def new_entities
      processor.process(feed_content).
        reject { |e| post_exists?(e[0]) }.
        map { |e| e[1] }
    end

    def feed_content
      RestClient.get(feed_info.url).body
    end

    def processor
      Service::FeedProcessor.for(feed_info.name)
    end

    def normalizer
      Service::EntityNormalizer.for(feed_info.name)
    end

    def post_exists?(link)
      Post.where(feed: feed, link: link).exists?
    end

    def create_post(entity)
      Rails.logger.info 'creating new post'
      Post.create!(entity.merge(feed: feed))
    rescue => e
      Rails.logger.error "error processing feed entity: #{e.message}"
      nil
    end
  end
end
