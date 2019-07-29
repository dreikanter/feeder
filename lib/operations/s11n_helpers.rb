module Operations
  module S11nHelpers
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
