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
        []
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
