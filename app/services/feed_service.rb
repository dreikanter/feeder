# Basic abstraction for feed services.
#
class FeedService
  attr_reader :feed

  # @param [Feed]
  def initialize(feed)
    @feed = feed
  end
end
