module FeedProcessors
  class NullProcessor < FeedProcessors::Base
    def entities
      []
    end
  end
end
