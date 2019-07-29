module Normalizers
  class Base
    include Callee

    param :entity
    param :options, default: proc { {} }

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

    SEPARATOR = ' - '.freeze

    def separator
      SEPARATOR
    end

    def valid?
      validation_errors.blank?
    end

    def validation_errors
      []
    end
  end
end
