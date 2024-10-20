module Freefeed
  class Request
    attr_reader :client, :request_method, :path, :payload

    def initialize(client:, request_method:, path:, payload: {})
      @client = client
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

    delegate :token, :base_url, :http_client, to: :client, private: true
  end
end
