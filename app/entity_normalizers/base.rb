module EntityNormalizers
  class Base
    def self.process(entity)
      send(:new, entity).send(:process)
    end

    protected

    attr_reader :entity

    def initialize(entity)
      @entity = entity
    end

    ATTRIBUTES = %w(link published_at text attachments comments)

    def process
      ATTRIBUTES.map { |a| [a, send(a)] }.to_h
    end

    def link
      nil
    end

    def published_at
      nil
    end

    def text
      nil
    end

    def attachments
      []
    end

    def comments
      []
    end
  end
end
