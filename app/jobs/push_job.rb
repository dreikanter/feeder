class PushJob < ApplicationJob
  queue_as :default

  def perform(post)
    raise 'post is stale' if post.stale?
    raise 'post is not ready' unless post.ready?
    post_id = create_freefeed_post
    post.update(freefeed_post_id: post_id, status: PostStatus.published)
  rescue StandardError
    post.update(status: PostStatus.error)
    raise
  end

  private

  def create_freefeed_post
    attach_ids = create_freefeed_attachments
    post_id = ff.create_post(
      post.text,
      feeds: [post.feed.name],
      attachments: attach_ids
    )
    create_freefeed_comments
    post_id
  end

  def create_freefeed_comments
    post.comments.each do |comment|
      ff.create_comment(post_id, comment)
    end
  end

  def create_freefeed_attachments
    post.attachments.map do |url|
      ff.create_attachment_from_url(url)
    end
  end

  def post
    arguments[0]
  end

  def ff
    @ff ||= Freefeed::Client.new(Rails.application.credentials.freefeed_token)
  end
end
