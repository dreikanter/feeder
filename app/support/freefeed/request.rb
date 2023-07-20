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
      error = Freefeed::Error.for(response)
      raise(error) if error
      response
    end

    private

    def uri
      @uri ||= URI.parse(client.base_url + path).to_s
    end

    def request_params
      options.slice(:json, :form, :params, :body)
    end

    def headers
      {
        accept: "*/*",
        user_agent: "feeder"
      }
    end
  end
end
