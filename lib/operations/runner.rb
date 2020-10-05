module Operations
  class Runner
    include Callee

    param :operation
    option :user
    option :params
    option :request

    option(
      :schema_resolver,
      options: true,
      default: -> { Operations::SchemaResolver }
    )

    option(
      :schema,
      optional: true,
      default: -> { schema_resolver.call(operation) }
    )

    def call
      Rails.logger.info("operation: #{operation}")
      validate_params
      operation.call(user: user, params: params, request: request)
    end

    private

    def validate_params
      acceptable_params = params.try(:to_unsafe_hash) || params
      result = schema.call(acceptable_params)
      raise bad_params(result) if result.failure?
    end

    def bad_params(result)
      Exceptions::BadParams.new(errors: result.errors, source: operation)
    end
  end
end
