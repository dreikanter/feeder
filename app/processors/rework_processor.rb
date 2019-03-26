require 'rss'

module Processors
  class ReworkProcessor < Processors::Base
    def entities
      items = RSS::Parser.parse(source).try(:items) || []

      items
        .map { |item| [item.guid.content, item] }
        .reject { |guid, _| guid.blank? }
        .to_h
    end
  end
end
