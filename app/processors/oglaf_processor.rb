module Processors
  class OglafProcessor < Processors::RssProcessor
    def items
      super.slice(0, 10)
    end

    def text(item)
      "#{item.title} - #{item.link}"
    end
  end
end
