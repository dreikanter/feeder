module FeedProcessors
  class LivejournalProcessor < FeedProcessors::RssProcessor
    def default_normalizer
      EntityNormalizers::LivejournalNormalizer
    end
  end
end
