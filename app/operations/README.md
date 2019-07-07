# Operations

Basic classes:

- [`Operations::Base`](../../lib/base.rb) — base operation class. Defines  accessors methods for the Rails actions context, and the public interface.
- [`Operations::BaseAuthorizer`](../../lib/base_authorizer.rb) — base authorizer class. An authorizer suppose to check if associated operation is allowed to serve current request for the current user.

Services:

- [`Operations::Performable`](../../lib/performable.rb) — controller concern to associate operations with Rails actions.
- [`Operations::Runner`](../../lib/runner.rb) — service class that executes operation sequence.

Resolvers:

- [`Operations::AuthorizerResolver`](../../lib/authorizer_resolver.rb) — resolves an authorizer class associated with the specified operation.
- [`Operations::SchemaResolver`](../../lib/schema_resolver.rb) — resolves a schema class associated with the specified operation.

Common cases:

- [`Operations::BypassAuthorizer`](../../lib/bypass_authorizer.rb) — an authorizer that allows all requests.
- [`Operations::BypassSchema`](../../lib/bypass_schema.rb) — an empty schema that accepts any params structure.
