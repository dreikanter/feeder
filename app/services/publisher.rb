# Takes a collection of posts, publishes each, updates post status.
# Does not interrupt on publication error.
#
class Publisher
  include Logging

  attr_reader :posts, :freefeed_client

  def initialize(posts:, freefeed_client:)
    @posts = posts
    @freefeed_client = freefeed_client
  end

  def publish
    logger.info("publishing #{TextHelpers.pluralize(pending_posts.count, "posts")}")

    pending_posts.each do |post|
      publish_post(post)
    end
  end

  private

  def pending_posts
    @pending_posts ||= posts.filter(&:pending?)
  end

  # :reek:UnusedParameters
  def publish_post(post)
    logger.info("publishing post: #{post.id}")
    # TBD
  end
end
