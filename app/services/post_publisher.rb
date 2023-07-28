class PostPublisher
  attr_reader :post

  def initialize(post)
    @post = post
  end

  # TODO: Consider removing `enqueued` state
  def publish
    return unless post.draft? || post.enqueued?
    post_id = create_post_with_attachments
    register_succeeded_publication(post_id)
  # rescue StandardError => e
  #   register_failed_publication(e)
  end

  private

  def create_post_with_attachments
    response = freefeed.create_post(post: {body: post.text, attachments: create_attachments}, meta: {feeds: [feed_name]})
    post_id = response.parse.dig("posts", "id")
    post.comments.each { freefeed.create_comment(comment: {body: _1, postId: post_id}) }
    post_id
  end

  delegate :feed, to: :post
  delegate :name, to: :feed, prefix: :feed

  def register_succeeded_publication(post_id)
    post.update!(freefeed_post_id: post_id)
    post.published!
    update_last_post_created_at
  end

  def register_failed_publication(error)
    post.fail!
    Honeybadger.notify(error)
  end

  def create_attachments
    post.attachments.map { create_attachment(_1) }
  end

  def create_attachment(url)
    Downloader.call(url) do |io, content_type|
      response = freefeed.create_attachment(io, content_type: content_type)
      response.parse.fetch("attachments").fetch("id")
    end
  end

  def freefeed
    @freefeed ||= FreefeedClientBuilder.call
  end

  def update_last_post_created_at
    feed.update(last_post_created_at: feed.posts.published.maximum(:created_at))
  end
end
