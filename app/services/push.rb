class Push
  include Callee

  param :post

  def call
    raise 'post is not ready' unless post.ready?
    publish_post_content
  end

  private

  def publish_post_content
    attachment_ids = create_attachments
    post_id = create_post(attachment_ids)
    post.update(freefeed_post_id: post_id)
    create_comments(post_id)
    post.update(status: PostStatus.published)
  rescue StandardError
    post.update(status: PostStatus.error)
    raise
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def create_post(attachment_ids)
    Logger.new($stdout).info(
      JSON.pretty_generate(
        post: {
          body: post.text,
          attachments: attachment_ids
        },
        meta: {
          feeds: [post.feed.name]
        }
      )
    )

    response = freefeed.create_post(
      post: {
        body: post.text,
        attachments: attachment_ids
      },
      meta: {
        feeds: [post.feed.name]
      }
    )

    response.parse.dig('posts', 'id')
  rescue StandardError => e
    Logger.new($stdout).info(JSON.pretty_generate(e.backtrace))
    raise
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

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
      response.parse.fetch('attachments').fetch('id')
    end
  end

  def freefeed
    @freefeed ||= FreefeedClientBuilder.call
  end
end
