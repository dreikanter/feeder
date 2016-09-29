module EntityNormalizers
  class Base
    def self.process(entity)
      send(:new, entity).send(:attributes)
    end

    protected

    def initialize(entity)
      @entity = entity
    end

    attr_reader :entity

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

    private

    def attribute_names
      %w(link published_at text attachments comments)
    end

    def attributes
      attribute_names.map { |a| [a, send(a)] }.to_h
    end
  end
end
