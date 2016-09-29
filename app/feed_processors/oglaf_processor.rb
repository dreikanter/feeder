module FeedProcessors
  class OglafProcessor < FeedProcessors::RssProcessor
    def limit
      10
    end
  end
end
