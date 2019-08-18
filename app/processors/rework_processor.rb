# TODO: Get rid of explicit require
require 'rss'

class ReworkProcessor < BaseProcessor
  protected

  def entities
    (RSS::Parser.parse(source).try(:items) || [])
      .map { |item| [item.guid.content, item] }
      .reject { |guid, _| guid.blank? }
      .to_h
  end
end
