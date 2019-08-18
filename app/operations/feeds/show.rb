module Feeds
  class Show < Operations::Base
    def call
      {
        json: {
          feed: s11n(feed, FeedSerializer),
          meta: meta
        }
      }
    end

    private

    def feed
      Feed.find_by!(name: name)
    end

    def name
      params.fetch(:name)
    end

    def meta
      {
        posts_per_week: PostsPerWeek.call(feed)
      }
    end
  end
end
