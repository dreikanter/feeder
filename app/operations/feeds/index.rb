module Operations
  module Feeds
    class Index < Operations::Base
      def call
        {
          json: feeds
        }
      end

      private

      def feeds
        names = Service::FeedsList.call.map { |feed| feed['name'] }
        Feed.where(name: names).order(:updated_at)
      end
    end
  end
end
