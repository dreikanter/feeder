require 'test_helper'

class PushJobTest < Minitest::Test
  def subject
    PushJob
  end

  def post(status: PostStatus.ready)
    @post ||= create(
      :post,
      status: status,
      comments: ['banana'],
      attachments: ['https://example.com/banana.jpg']
    )
  end

  # rubocop:disable Metrics/MethodLength
  def setup
    super

    # Fetch attachment
    stub_request(:get, 'https://example.com/banana.jpg')
      .to_return(
        headers: { content_type: 'image/jpg' },
        body: 'banana'
      )

    # Create attachment
    stub_request(:post, 'https://candy.freefeed.net/v1/attachments')
      .to_return(
        headers: { content_type: 'application/json' },
        body: { 'attachments' => { 'id' => ATTACHMENT_ID } }.to_json
      )

    # Create post
    stub_request(:post, 'https://candy.freefeed.net/v1/posts')
      .with(
        body: {
          post: {
            'body' => 'Sample post text',
            'attachments' => [ATTACHMENT_ID]
          },
          meta: { 'feeds' => ['sample'] }
        }.to_json
      )
      .to_return(
        headers: { content_type: 'application/json' },
        body: { 'posts' => { 'id' => POST_ID } }.to_json
      )

    # Create comment
    stub_request(:post, 'https://candy.freefeed.net/v1/comments')
      .with(
        body: {
          'comment' => {
            'body' => 'banana',
            'postId' => POST_ID
          }
        }.to_json
      )
  end
  # rubocop:enable Metrics/MethodLength

  POST_ID = '1'
  ATTACHMENT_ID = '101'

  def test_perform
    subject.perform_now(post)
    post.reload
    assert(post.published?)
    assert_equal(POST_ID, post.freefeed_post_id)
  end
end
