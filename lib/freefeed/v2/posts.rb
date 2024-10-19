module Freefeed
  module V2
    module Posts
      include Freefeed::Utils

      def post(id)
        authenticated_request(:get, "/v2/posts/#{id}")
      end

      def post_open_graph(id)
        authenticated_request(:get, "/v2/posts-opengraph/#{id}")
      end
    end
  end
end
