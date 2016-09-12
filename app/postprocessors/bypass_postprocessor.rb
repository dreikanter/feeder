module Postprocessors
  class BypassPostprocessor < Postprocessors::Base
    def process(entity)
      return entity
    end
  end
end
