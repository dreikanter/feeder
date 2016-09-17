module FeedProcessors
  class OglafProcessor < FeedProcessors::RssProcessor
    def entities
      super.slice(0, 10)
    end
  end
end
