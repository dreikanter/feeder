class PostPublisher
  attr_reader :post

  def initialize(post)
    @post = post
  end

  # TODO: Consider removing `enqueued` state
  def publish
    post.reject! if post.validation_errors?
    return unless post.draft? || post.enqueued?
    Push.call
    post.published!
    update_last_post_created_at
  rescue StandardError
    post.fail!
  end

  def update_last_post_created_at
    feed.update(last_post_created_at: feed.posts.published.maximum(:created_at))
  end
end
