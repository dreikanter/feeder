module Operations
  class Base
    def self.call(context)
      self.new(context).call
    end

    attr_reader :context

    def initialize(context = {})
      @context = context
    end

    def user
      context[:user]
    end

    def params
      context[:params]
    end

    def request
      context[:request]
    end

    def options
      context[:options] || {}
    end

    def call
      raise NotImplementedError
    end

    # TODO: Move helper methods to services

    def s11n(object, serializer = nil)
      return object.as_json unless serializer

      ActiveModelSerializers::SerializableResource.new(
        object,
        adapter: :attributes,
        serializer: serializer
      ).as_json
    end

    def each_s11n(array, serializer = nil)
      return array.as_json unless serializer

      ActiveModelSerializers::SerializableResource.new(
        array,
        adapter: :attributes,
        each_serializer: serializer
      ).as_json
    end
  end
end
