module Processors
  class TestProcessor < Processors::Base
    ENTITIES = [
      %w[uid0 entity0],
      %w[uid1 entity1],
      %w[uid2 entity2]
    ].freeze

    protected

    def entities
      ENTITIES
    end
  end
end
