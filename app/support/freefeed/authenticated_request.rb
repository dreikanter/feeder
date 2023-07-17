# frozen_string_literal: true

module Freefeed
  class AuthenticatedRequest < Request
    private

    def headers
      super.merge(authorization: "Bearer #{client.token}")
    end
  end
end
