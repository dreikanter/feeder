module Operations
  module Feeds
    module API
      class Show < Operations::Base
        def call
          {
            json: feed
          }
        end

        private

        def feed
          Feed.find(id)
        end

        def id
          params.fetch(:id)
        end
      end
    end
  end
end
