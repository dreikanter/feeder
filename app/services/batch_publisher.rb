# Takes a collection of posts, publishes each, updates post status.
# Does not interrupt on publication error.
#
class BatchPublisher
  include Logging

  attr_reader :posts, :freefeed_client, :publisher_class

  def initialize(posts:, freefeed_client:, publisher_class: PostPublisher)
    @posts = posts
    @freefeed_client = freefeed_client
    @publisher_class = publisher_class
  end

  def publish
    logger.info("publishing #{TextHelpers.pluralize(posts.count, "posts")}")

    posts.each do |post|
      logger.info("publishing post: #{post.id}")
      publish_post(post)
    end
  end

  private

  def publish_post(post)
    post.with_lock do
      next unless post.reload.enqueued?
      publisher_class.new(post: post, freefeed_client: freefeed_client).publish
    end
  end
end
