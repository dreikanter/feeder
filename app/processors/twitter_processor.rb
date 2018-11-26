require 'rss'

module Processors
  class TwitterProcessor < Processors::Base
    def entities
      source.map { |entity| [entity['id'].to_s, entity] }
    end
  end
end
