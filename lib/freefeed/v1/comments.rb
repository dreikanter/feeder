# frozen_string_literal: true

module Freefeed
  module V1
    module Comments
      def create_comment(comment)
        authenticated_request(:post, "/v1/comments", json: comment)
      end

      def update_comment(id, comment)
        authenticated_request(:put, "/v1/comments/#{id}", json: comment)
      end

      def delete_comment(id)
        authenticated_request(:delete, "/v1/comments/#{id}")
      end
    end
  end
end
