module Freefeed
  class Client
    include Freefeed::V1::Attachments
    include Freefeed::V1::Comments
    include Freefeed::V1::Posts
    include Freefeed::V2::Notifications
    include Freefeed::V2::Posts
    include Freefeed::V2::Timelines
    include Freefeed::V2::Users

    attr_reader :token, :base_url

    def initialize(token:, base_url: Freefeed::BASE_URL)
      @token = token
      @base_url = base_url
    end
  end
end
