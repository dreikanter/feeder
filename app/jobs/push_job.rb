class PushJob < ApplicationJob
  queue_as :default

  def perform(post)
    if post.ignored?
      logger.info('ignoring non-valid post')
      return
    end

    raise "unexpected post status: #{post.status}" unless post.ready?
    post_id = create_freefeed_post
    post.update(freefeed_post_id: post_id, status: PostStatus.published)
  rescue StandardError
    post.update(status: PostStatus.error)
    raise
  end

  private

  def create_freefeed_post # rubocop:disable Metric/AbcSize
    attach_ids = post.attachments.map do |url|
      ff.create_attachment_from_url(url)
    end
    post_id = ff.create_post(
      post.text,
      feeds: [post.feed.name],
      attachments: attach_ids
    )
    post.comments.each do |comment|
      ff.create_comment(post_id, comment)
    end
    post_id
  end

  def post
    arguments[0]
  end

  def ff
    @ff ||= Freefeed::Client.new(Rails.application.credentials.freefeed_token)
  end
end
