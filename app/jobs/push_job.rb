class PushJob < ApplicationJob
  queue_as :default

  def perform(post)
    if post.ignored?
      logger.info('ignoring non-valid post')
      return
    end

    unless post.ready?
      logger.error("unexpected post status: #{post.status}")
      return
    end

    post_id = create_freefeed_post
    post.update(freefeed_post_id: post_id, status: PostStatus.published)
  rescue StandardError
    post.update(status: PostStatus.error)
    raise
  end

  private

  def create_freefeed_post
    attach_ids = post.attachments.map do |url|
      FileDownloader.call(url) { |file| freefeed.create_attachment(file) }
    end

    post_id = freefeed.create_post(
      post.text,
      feeds: [post.feed.name],
      attachments: attach_ids
    )

    post.comments.each do |comment|
      freefeed.create_comment(post_id, comment)
    end

    post_id
  end

  def create_attachment(url)
    FileDownloader.call(url) do |file|
      freefeed.create_attachment(file)
    end
  end

  def post
    arguments[0]
  end

  def freefeed
    @freefeed ||= FreefeedClientBuilder.call
  end
end
