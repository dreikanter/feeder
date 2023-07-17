# frozen_string_literal: true

module Freefeed
  module V2
    module Notifications
      include Freefeed::Utils

      def notifications
        authenticated_request(:get, "/v2/notifications")
      end
    end
  end
end
