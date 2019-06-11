module Operations
  module Updates
    class Index < Operations::Base
      def call
        {
          json: {
            updates: updates,
            meta: meta
          }
        }
      end

      private

      def updates
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
