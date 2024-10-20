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

    def initialize(token:, base_url: Freefeed::BASE_URL, http_client: nil)
      @token = token
      @base_url = base_url
      @http_client = http_client
    end

    def http_client
      @http_client ||= HTTP.follow(max_hops: 3).timeout(5)
    end
  end
end
