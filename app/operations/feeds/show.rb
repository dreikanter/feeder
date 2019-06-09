module Operations
  module Feeds
    class Show < Operations::Base
      def call
        {
          json: feed,
          meta: meta
        }
      end

      private

      def feed
        Feed.find(id)
      end

      def id
        params.fetch(:id)
      end

      def meta
        {}
      end
    end
  end
end
