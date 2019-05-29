module Operations
  class AuthorizerResolver
    SUFFIX = 'Authorizer'.freeze

    def self.call(operation)
      [operation.name, SUFFIX].join.safe_constantize ||
        Operations::BypassAuthorizer
    end
  end
end
