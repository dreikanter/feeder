module Operations
  class SchemaResolver
    SUFFIX = 'Schema'.freeze
    DEFAULT_SCHEMA = Operations::BypassSchema

    def self.call(operation)
      [operation.name, SUFFIX].join.safe_constantize || DEFAULT_SCHEMA
    end
  end
end
