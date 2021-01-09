# frozen_string_literal: true

module Freefeed
  class Error < StandardError
    ClientError = Class.new(self)
    ServerError = Class.new(self)

    BadRequest = Class.new(ClientError)
    Forbidden = Class.new(ClientError)
    NotAcceptable = Class.new(ClientError)
    NotFound = Class.new(ClientError)
    RequestEntityTooLarge = Class.new(ClientError)
    TooManyRequests = Class.new(ClientError)
    Unauthorized = Class.new(ClientError)
    UnprocessableEntity = Class.new(ClientError)

    BadGateway = Class.new(ServerError)
    GatewayTimeout = Class.new(ServerError)
    InternalServerError = Class.new(ServerError)
    ServiceUnavailable = Class.new(ServerError)

    ERRORS = {
      400 => Freefeed::Error::BadRequest,
      401 => Freefeed::Error::Unauthorized,
      403 => Freefeed::Error::Forbidden,
      404 => Freefeed::Error::NotFound,
      406 => Freefeed::Error::NotAcceptable,
      413 => Freefeed::Error::RequestEntityTooLarge,
      422 => Freefeed::Error::UnprocessableEntity,
      429 => Freefeed::Error::TooManyRequests,
      500 => Freefeed::Error::InternalServerError,
      502 => Freefeed::Error::BadGateway,
      503 => Freefeed::Error::ServiceUnavailable,
      504 => Freefeed::Error::GatewayTimeout
    }.freeze

    # TODO: Populate error object with details
    def self.for(response)
      ERRORS[response.code]
    end
  end
end
