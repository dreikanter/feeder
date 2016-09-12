module Service
  class Postprocessor
    def self.for(feed_name)
      "postprocessors/#{feed_name}_postprocessor".classify.constantize
    rescue
      Postprocessors::BypassPostprocessor
    end
  end
end
