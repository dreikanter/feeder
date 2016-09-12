module Processors
  class OglafProcessor < Processors::RssProcessor
    def process
      super.slice(0, 2)
    end

    def description(item)
      ''
    end
  end
end
