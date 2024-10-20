module Freefeed
  module Utils
    def authenticated_request(request_method, path, payload = {})
      AuthenticatedRequest.new(
        client: self,
        request_method: request_method,
        path: path,
        payload: payload
      ).perform
    end

    def request(request_method, path, payload = {})
      Request.new(
        client: self,
        request_method: request_method,
        path: path,
        payload: payload
      ).perform
    end
  end
end
