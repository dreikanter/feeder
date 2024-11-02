class PostPublisher
  include Logging

  attr_reader :post, :freefeed_client

  def initialize(post:, freefeed_client:)
    @post = post
    @freefeed_client = freefeed_client
  end

  # TBD :reek:TooManyStatements
  def publish
    attachment_ids = create_attachments
    post_id = create_post(attachment_ids)
    post.update(freefeed_post_id: post_id)
    create_comments(post_id)
    post.success!
    logger.info("---> new post URL: #{post.permalink}")
  rescue StandardError
    post.fail!
    # TBD: Report error
  end

  private

  def create_post(attachment_ids)
    response = freefeed_client.create_post(
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
      freefeed_client.create_comment(
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
    Freefeed::Downloader.new(url: url).call do |io, content_type|
      response = freefeed_client.create_attachment(io, content_type: content_type)
      response.parse.fetch("attachments").fetch("id")
    end
  end
end
