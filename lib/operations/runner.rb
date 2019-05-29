module Operations
  class Runner
    def self.call(operation, context)
      Rails.logger.info("operation: #{operation}")
      new(operation, context).call
    end

    attr_reader :operation
    attr_reader :context

    # TODO: Standardize sanitizers interface

    def initialize(operation, context)
      @operation = operation
      @context = context
    end

    def call
      process_params_with_schema
      authorize_user
      perform_operation
    end

    private

    # NOTE: Dry::Validation.Schema suppose to accept params object as is,
    # but this don't actually work. For this reason to_unsafe_hash conversion
    # is used for now.
    def process_params_with_schema
      schema = Operations::SchemaResolver.call(operation)
      acceptable_params = params.try(:to_unsafe_hash) || params
      result = schema.call(acceptable_params)
      return if result.success?
      raise Exceptions::BadParams.new(errors: result.errors, source: operation)
    end

    def authorize_user
      authorizer = Operations::AuthorizerResolver.call(operation)
      result = authorizer.call(user: user, params: params)
      return if result.success?
      raise Exceptions::NotAuthorized.new(
        errors: result.payload,
        source: operation
      )
    end

    def perform_operation
      operation.call(context)
    end

    def user
      context[:user]
    end

    def params
      context[:params]
    end
  end
end
