module Operations
  module Feeds
    class Index < Operations::Base
      def call
        {
          json: {
            feeds: feeds,
            meta: meta
          }
        }
      end

      private

      ORDER_FIELD = 'last_post_created_at'.freeze
      FEEDS_ORDER = Arel.sql("#{ORDER_FIELD} IS NULL, #{ORDER_FIELD} DESC")

      private_constant :ORDER_FIELD, :FEEDS_ORDER

      def feeds
        each_s11n(Feed.active.order(FEEDS_ORDER), BriefFeedSerializer)
      end

      def meta
        {
          feeds_count: Feed.count,
          posts_count: Post.count,
          subscriptions_count: subscriptions_count,
          last_post_created_at: last_post_created_at,
          last_update: last_update
        }
      end

      def last_update
        DataPoint.ordered.for('pull').first.try(:created_at)
      end

      def last_post_created_at
        Post.order(created_at: :desc).first.try(:created_at)
      end

      def subscriptions_count
        Feed.sum(:subscriptions_count)
      end
    end
  end
end
