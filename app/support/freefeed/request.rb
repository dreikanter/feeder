# frozen_string_literal: true

module Freefeed
  class Request
    include HttpClient
    extend Dry::Initializer

    param :client
    param :request_method
    param :path
    param :options, optional: true, default: -> { {} }

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
  end
end
