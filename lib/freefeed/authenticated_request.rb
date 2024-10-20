module Freefeed
  class AuthenticatedRequest < Request
    private

    def headers
      super.merge(authorization: "Bearer #{token}")
    end
  end
end
