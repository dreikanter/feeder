# Controller concern defining helper method to execute operations
#
module Operations
  module Performable
    extend ActiveSupport::Concern

    protected

    def perform(operation, options = {})
      render(Operations::Runner.call(
               operation,
        user: try(:current_user),
        params: try(:params),
        request: try(:request),
        **options
      ))
    end
  end
end
