# Controller concern defining helper method to execute operations
#
module Operations
  module Performable
    extend ActiveSupport::Concern

    protected

    def perform(operation, options = {})
      params = {
        user: try(:current_user),
        params: try(:params),
        request: try(:request),
        options: options
      }

      render(Operations::Runner.call(operation, params))
    end
  end
end
