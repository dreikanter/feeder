module Processors
  class OglafProcessor < Processors::RssProcessor
    def process
      super.slice(0, 10)
    end

    def description(item)
      ''
    end
  end
end
