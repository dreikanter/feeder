class PushJob < ApplicationJob
  queue_as :default

  # TODO: Update post.status on error
  # post.update(status: :error)

  def perform(post)
    raise 'post is stale' if post.stale?
    raise 'post is not ready' unless post.ready?

    attach_ids = post.attachments.map do |url|
      # TODO: Move API logging to the wrapper class
      logger.info("create new attachment for #{url}")
      re = ff.create_attachment_from_url(url)
      attach_id = re['attachments']['id']
      logger.info("attachment id: #{attach_id}")
      attach_id
    end

    logger.info('create new post')
    feed_name = post.feed&.name
    feeds = feed_name ? [feed_name] : []
    re = ff.create_post(post.text, feeds: feeds, attachments: attach_ids)
    post_id = re.dig('posts', 'id')

    post.update(freefeed_post_id: post_id)

    post.comments.each do |comment|
      logger.info('creating new comment')
      ff.create_comment(post_id, comment)
    end

    post.update(status: PostStatus.published)
  rescue StandardError
    post.update(status: PostStatus.error)
    raise
  end

  private

  def ff
    @ff ||= Freefeed::Client.new(Rails.application.credentials.freefeed_token)
  end
end
