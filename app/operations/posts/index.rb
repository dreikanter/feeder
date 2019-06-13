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
        {
          feed_name: feed_name
        }
      end

      def feed_name
        params[:feed_name]
      end
    end
  end
end
