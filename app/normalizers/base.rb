module Normalizers
  class Base
    extend Dry::Initializer

    param :entity
    param :options, default: proc { {} }

    def self.call(entity, options = {})
      new(entity, options).call
    end

    ATTRIBUTE_NAMES = %w[
      link
      published_at
      text
      attachments
      comments
    ].freeze

    def call
      return ::Failure.new(validation_errors) unless valid?
      ::Success.new(ATTRIBUTE_NAMES.map { |attr| [attr, send(attr)] }.to_h)
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

    def validation_errors
      nil
    end
  end
end
