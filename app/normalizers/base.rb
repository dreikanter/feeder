module Normalizers
  class Base
    extend Dry::Initializer

    param :entity

    def self.call(entity)
      new(entity).call
    end

    ATTRIBUTE_NAMES = %w[
      link
      published_at
      text
      attachments
      comments
    ].freeze

    def call
      ATTRIBUTE_NAMES.map { |a| [a, send(a)] }.to_h if valid?
    end

    protected

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
  end
end
