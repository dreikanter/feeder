module Operations
  module Activity
    class Show < Operations::Base
      # TODO: Consider moving this to configuration
      HISTORY_DEPTH = 1.year.ago

      def call
        {
          json: {
            activity: posts_per_day,
            meta: meta
          }
        }
      end

      private

      def posts_per_day
        posts.group('DATE(created_at)').count.sort.to_h
      end

      def posts
        scope = Post.where('created_at > ?', HISTORY_DEPTH)
        return scope unless feed_name
        scope.where(feed: feed)
      end

      def meta
        {
          feed_name: feed_name
        }
      end

      def feed
        Feed.find_by(name: feed_name)
      end

      def feed_name
        params[:feed_name]
      end
    end
  end
end
