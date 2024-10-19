module Freefeed
  module V1
    module Posts
      include Freefeed::Utils

      def create_post(post)
        authenticated_request(:post, "/v1/posts", json: post)
      end

      def update_post(id, post)
        authenticated_request(:put, "/v1/posts/#{id}", json: post)
      end

      def delete_post(id)
        authenticated_request(:delete, "/v1/posts/#{id}")
      end

      def like(id)
        authenticated_request(:post, "/v1/posts/#{id}/like")
      end

      def unlike(id)
        authenticated_request(:post, "/v1/posts/#{id}/unlike")
      end

      def hide(id)
        authenticated_request(:post, "/v1/posts/#{id}/hide")
      end

      def unhide(id)
        authenticated_request(:post, "/v1/posts/#{id}/unhide")
      end

      def save(id)
        authenticated_request(:post, "/v1/posts/#{id}/save")
      end

      def unsave(id)
        authenticated_request(:delete, "/v1/posts/#{id}/save")
      end

      def disable_comments(id)
        authenticated_request(:post, "/v1/posts/#{id}/disableComments")
      end

      def enable_comments(id)
        authenticated_request(:post, "/v1/posts/#{id}/enableComments")
      end
    end
  end
end
