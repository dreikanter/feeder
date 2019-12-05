class PushJob < ApplicationJob
  queue_as :default

  # TODO: Move publication to a service class
  # TODO: Test coverage
  # TODO: Use data objects for Freefeed API wrapper

  def perform(post)
    if post.ignored?
      logger.info('ignoring non-valid post')
      return
    end

    unless post.ready?
      logger.error("unexpected post status: #{post.status}")
      return
    end

    create_post_with_comments
    post.update(status: PostStatus.published)
  rescue StandardError
    post.update(status: PostStatus.error)
    raise
  end

  private

  def create_post_with_comments
    attachment_ids = create_attachments
    post_id = create_post(attachment_ids)
    post.update(freefeed_post_id: post_id)
    create_comments(post_id)
  end

  def create_post(attachment_ids)
    freefeed.create_post(
      post: {
        body: post.text,
        attachments: attachment_ids
      },
      meta: {
        feeds: [post.feed.name]
      }
    )
  end

  def create_comments(post_id)
    post.comments.each do |comment|
      freefeed.create_comment(
        comment: {
          body: comment,
          postId: post_id
        }
      )
    end
  end

  def create_attachments
    post.attachments.map { |url| create_attachment(url) }
  end

  def create_attachment(url)
    Downloader.call(url) do |io, content_type|
      response = freefeed.create_attachment(io, content_type: content_type)
      response.dig('attachments', 'id')
    end
  end

  def post
    arguments[0]
  end

  def freefeed
    @freefeed ||= FreefeedClientBuilder.call
  end
end
