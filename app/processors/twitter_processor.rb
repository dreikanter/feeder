module Processors
  class TwitterProcessor < Processors::Base
    protected

    def entities
      pick_uid = ->(entity) { [entity.fetch('id').to_s, entity] }
      tweets.map(&pick_uid).to_h
    end

    def tweets
      source.as_json
    end
  end
end
