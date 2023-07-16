class Push
  include Logging
  include Callee

  param :post

  def call
    publish_post_content

    # TODO: Use better way to limit API calls rate
    sleep 1
  end

  private

  def publish_post_content
    attachment_ids = create_attachments
    post_id = create_post(attachment_ids)
    post.update(freefeed_post_id: post_id)
    create_comments(post_id)
    # TODO: post.success!
    log_info("---> new post URL: #{post.permalink}")
    # rescue StandardError
    #   post.fail!
    #   raise
  end

  def create_post(attachment_ids)
    response = freefeed.create_post(
      post: {
        body: post.text,
        attachments: attachment_ids
      },
      meta: {
        feeds: [post.feed.name]
      }
    )

    response.parse.dig("posts", "id")
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
      response.parse.fetch("attachments").fetch("id")
    end
  end

  def freefeed
    @freefeed ||= FreefeedClientBuilder.call
  end
end
