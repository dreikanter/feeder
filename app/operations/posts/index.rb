module Operations
  module Posts
    class Index < Operations::Base
      def call
        {
          json: {
            posts: posts,
            meta: meta
          }
        }
      end

      private

      def posts
        each_s11n(Post.includes(:feed).recent, PostSerializer)
      end

      def meta
        return { feed_name: feed_name } if individual_feed?
        { feeds: feeds }
      end

      def individual_feed?
        feed_name.present?
      end

      def feed_name
        params[:feed_name]
      end

      def feeds
        each_s11n(Feed.active, FeedSerializer)
      end
    end
  end
end
