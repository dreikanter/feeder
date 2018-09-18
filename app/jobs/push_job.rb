class PushJob < ApplicationJob
  queue_as :default

  rescue_from StandardError do |exception|
    Rails.logger.error exception
    Error.dump(exception, context: { class_name: self.class.name })
    post = self.arguments.first
    post.update(status: :error)
  end

  def perform(post)
    if Post.stale?
      Rails.logger.warn "post is stale; skipping"
      return
    end

    unless post.ready?
      Rails.logger.warn "post is not ready; skipping"
      return
    end

    ff = Freefeed::Client.new(ENV['FREEFEED_TOKEN'])

    attach_ids = post.attachments.reject(&:blank?).map do |url|
      logger.info "create new attachment for #{url}"
      re = ff.create_attachment_from_url(url)
      attach_id = re['attachments']['id']
      logger.info "attachment id: #{attach_id}"
      attach_id
    end

    logger.info 'create new post'
    re = ff.create_post(post.text, feeds: post.feeds, attachments: attach_ids)
    post_id = re['posts']['id']
    logger.info "post id: #{post_id}"

    post.update(freefeed_post_id: post_id)

    post.comments.reject(&:blank?).each do |comment|
      logger.info 'creating new comment'
      ff.create_comment(post_id, comment)
    end

    post.update(status: :published)
  end
end
