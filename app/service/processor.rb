module Service
  class Processor
    def self.for(feed_name)
      "processors/#{feed_name}_processor".classify.constantize
    rescue
      Processors::NullProcessor
    end
  end
end
