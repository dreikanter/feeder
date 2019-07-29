class PushJob < ApplicationJob
  queue_as :default

  def perform(post)
    raise 'post does not exist' unless post.present?
    raise 'post is stale' if post.stale?
    raise 'post is not ready' unless post.ready?

    ff = Freefeed::Client.new(Rails.application.credentials.freefeed_token)

    attach_ids = post.attachments.reject(&:blank?).map do |url|
      logger.info("create new attachment for #{url}")
      re = ff.create_attachment_from_url(url)
      attach_id = re['attachments']['id']
      logger.info("attachment id: #{attach_id}")
      attach_id
    end

    logger.info('create new post')
    re = ff.create_post(post.text, feeds: post.feeds, attachments: attach_ids)
    post_id = re['posts']['id']
    logger.info("post id: #{post_id}")

    post.update(freefeed_post_id: post_id)

    post.comments.reject(&:blank?).each do |comment|
      logger.info('creating new comment')
      ff.create_comment(post_id, comment)
    end

    post.update(status: :published)
  end

  def on_error
    post = arguments.first
    post.update(status: :error)
  rescue StandardError => e
    logger.error("---> error handling exception: #{e.message}")
    Error.dump(e, class_name: class_name)
  end
end
