module Freefeed
  module Utils
    def authenticated_request(request_method, path, params = {})
      AuthenticatedRequest.new(
        client: self,
        request_method: request_method,
        path: path,
        options: params
      ).call
    end

    def request(request_method, path, params = {})
      Request.new(
        client: self,
        request_method: request_method,
        path: path,
        options: params
      ).call
    end
  end
end
