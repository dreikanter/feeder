module Operations
  module Feeds
    class Show < Operations::Base
      def call
        {
          json: {
            feed: feed,
            meta: meta
          }
        }
      end

      private

      def feed
        Feed.find_by(name: name)
      end

      def name
        params.fetch(:name)
      end

      def meta
        {}
      end
    end
  end
end
