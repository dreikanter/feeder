module Freefeed
  class Request
    DEFAULT_OPTIONS = {
      http_max_hops: 3,
      http_timeout_seconds: 5
    }.freeze

    attr_reader :client, :request_method, :path, :options

    def initialize(client:, request_method:, path:, options: {})
      @client = client
      @request_method = request_method
      @path = path
      @options = options
    end

    def call
      response = http.headers(headers).public_send(request_method, uri, **request_params)
      ensure_successful_response(response)
      response
    end

    private

    def ensure_successful_response(response)
      error = Freefeed::Error.for(response)
      return unless error
      Honeybadger.context(failed_request_params: request_params)
      raise(error)
    end

    def uri
      @uri ||= URI.parse(client.base_url + path).to_s
    end

    def request_params
      @request_params ||= options.slice(:json, :form, :params, :body)
    end

    def headers
      {
        accept: "*/*",
        user_agent: "feeder"
      }
    end

    def http
      HTTP.follow(max_hops: option(:http_max_hops)).timeout(option(:http_timeout_seconds))
    end

    def option(option_name)
      options.fetch(option_name) { DEFAULT_OPTIONS.fetch(option_name) }
    end
  end
end
