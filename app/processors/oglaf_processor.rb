module Processors
  class OglafProcessor < Processors::RssProcessor
    def items
      super.slice(0, 10)
    end

    def description(item)
      ''
    end
  end
end
