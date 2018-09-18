module Normalizers
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

    def separator
      ' - '
    end

    def valid?
      true
    end

    ATTRIBUTE_NAMES = %w[
      link
      published_at
      text
      attachments
      comments
    ].freeze

    private

    def attributes
      ATTRIBUTE_NAMES.map { |a| [a, send(a)] }.to_h if valid?
    end
  end
end
