module Freefeed
  class Request
    attr_reader :base_url, :http_client, :request_method, :path, :payload

    def initialize(http_client:, base_url:, request_method:, path:, payload: {})
      @base_url = base_url
      @http_client = http_client
      @request_method = request_method
      @path = path
      @payload = payload
    end

    def perform
      response = http_client.headers(headers).public_send(request_method, uri, **payload)
      ensure_successful_response(response)
      response
    end

    private

    def ensure_successful_response(response)
      error = Freefeed::Error.for(response)
      return unless error
      # TBD: Honeybadger.context(failed_request_payload: payload)
      raise(error)
    end

    def uri
      URI.parse(base_url + path).to_s
    end

    def headers
      {
        accept: "*/*",
        user_agent: "feeder"
      }
    end
  end
end
