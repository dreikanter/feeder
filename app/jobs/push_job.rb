class PushJob < ApplicationJob
  queue_as :default

  def perform(post)
    raise 'post does not exist' unless post.present?
    raise 'post is stale' if post.stale?
    raise 'post is not ready' unless post.ready?

    attach_ids = post.attachments.reject(&:blank?).map do |url|
      # TODO: Move logging to the API wrapper
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

    # TODO: Drop redundant blank check
    post.comments.reject(&:blank?).each do |comment|
      logger.info('creating new comment')
      ff.create_comment(post_id, comment)
    end

    post.update(status: :published)
  end

  private

  def ff
    @ff ||= Freefeed::Client.new(Rails.application.credentials.freefeed_token)
  end

  # TODO: Update post.status
  # def on_error
  #   post = arguments.first
  #   post.update(status: :error)
  # rescue StandardError => e
  #   logger.error("---> error handling exception: #{e.message}")
  #   Error.dump(e, class_name: class_name)
  # end
end
