class Publisher
  include LoggingHelper

  def initialize(posts:)
    @posts = posts
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
    # TBD
  end
end
