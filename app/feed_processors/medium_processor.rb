module FeedProcessors
  class MediumProcessor < FeedProcessors::RssProcessor
    def default_normalizer
      EntityNormalizers::MediumNormalizer
    end
  end
end
