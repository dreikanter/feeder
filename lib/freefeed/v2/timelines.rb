# frozen_string_literal: true

# :reek:DataClump
module Freefeed
  module V2
    module Timelines
      include Freefeed::Utils

      def best_of
        authenticated_request(:get, "/v2/bestof")
      end

      def everything
        request(:get, "/v2/everything")
      end

      def own_timeline(filter: nil, offset: 0)
        request_timeline(filter ? "filter/#{filter}" : "home", offset)
      end

      def timeline(username, offset: 0)
        request_timeline(username, offset)
      end

      def comments_timeline(username, offset: 0)
        request_timeline("#{username}/comments", offset)
      end

      def likes_timeline(username, offset: 0)
        request_timeline("#{username}/likes", offset)
      end

      private

      def request_timeline(path, offset)
        params = offset.positive? ? {json: {offset: offset}} : {}
        authenticated_request(:get, "/v2/timelines/#{path}", params)
      end
    end
  end
end
