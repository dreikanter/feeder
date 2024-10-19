module Freefeed
  module V2
    module Users
      def whoami
        authenticated_request(:get, "/v2/users/whoami")
      end

      def blocked_by_me
        authenticated_request(:get, "/v2/users/blockedByMe")
      end

      def unread_directs_number
        authenticated_request(:get, "/v2/users/getUnreadDirectsNumber")
      end

      def unread_notifications_number
        authenticated_request(:get, "/v2/users/getUnreadNotificationsNumber")
      end

      def mark_all_directs_as_read
        authenticated_request(:get, "/v2/users/markAllDirectsAsRead")
      end

      def mark_all_notifications_as_read
        authenticated_request(:post, "/v2/users/markAllNotificationsAsRead")
      end
    end
  end
end
