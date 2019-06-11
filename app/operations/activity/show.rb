module Operations
  module Activity
    class Show < Operations::Base
      def call
        {
          json: {
            activity: activity,
            meta: meta
          }
        }
      end

      private

      def activity
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
