# frozen_string_literal: true

module Freefeed
  class Client
    extend Dry::Initializer

    include Freefeed::V1::Attachments
    include Freefeed::V1::Comments
    include Freefeed::V1::Posts

    option :token
    option :base_url, default: -> { Freefeed::BASE_URL }
    option :http_features, default: -> { {} }
  end
end
