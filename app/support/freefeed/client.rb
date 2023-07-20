# frozen_string_literal: true

module Freefeed
  class Client
    extend Dry::Initializer

    include Freefeed::V1::Attachments
    include Freefeed::V1::Comments
    include Freefeed::V1::Posts
    include Freefeed::V2::Notifications
    include Freefeed::V2::Posts
    include Freefeed::V2::Timelines
    include Freefeed::V2::Users

    option :token
    option :base_url, default: -> { Freefeed::BASE_URL }
  end
end
