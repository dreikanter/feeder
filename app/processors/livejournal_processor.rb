module Processors
  class LivejournalProcessor < Processors::RssProcessor
    MAX_COMMENT_LENGTH = 500
    OMISSION = '... (continued)'

    def items
      RSS::Parser.parse(source).items
    end

    def text(item)
      [item.title, item.link].reject(&:blank?).join(' - ')
    end

    def comments(item)
      super << excerpt(item)
    end

    def process_item(item)
      @description = Nokogiri::HTML(item.description)
      super
    end

    def excerpt(item)
      @description.text.squeeze(" \n").
        truncate(MAX_COMMENT_LENGTH, separator: ' ', omission: OMISSION)
    end

    def attachments(item)
      image = @description.css('img:first').first.try(:[], 'src')
      super + (image ? [image] : [])
    end
  end
end
