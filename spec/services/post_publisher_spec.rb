RSpec.describe PostPublisher do
  subject(:service) { described_class.new(post: post, freefeed_client: freefeed_client) }

  let(:freefeed_client) do
    Freefeed::Client.new(
      token: "TEST_TOKEN",
      base_url: "https://freefeed.test"
    )
  end

  let(:feed) { create(:feed, name: "sample_feed") }

  let(:json_headers_with_authentication_token) do
    {
      "Accept" => "*/*",
      "Authorization" => "Bearer TEST_TOKEN",
      "Connection" => "close",
      "Content-Type" => "application/json; charset=utf-8",
      "Host" => "freefeed.test",
      "User-Agent" => "feeder"
    }
  end

  describe "#publish" do
    it "publishes a post" do
      post = create(
        :post,
        feed: feed,
        state: "enqueued",
        attachments: [],
        comments: []
      )

      # Create post
      stub_request(:post, "https://freefeed.test/v1/posts")
        .with(
          body: {
            "post" => {
              "body" => "Sample post text",
              "attachments" => []
            },
            "meta" => {
              "feeds" => [feed.name]
            }
          }.to_json,
          headers: json_headers_with_authentication_token
        )
        .to_return(
          status: 200,
          body: {
            "posts" => {
              "id" => "TEST_POST_ID"
            }
          }.to_json,
          headers: {
            "Content-Type" => "application/json; charset=utf-8"
          }
        )

      publisher = described_class.new(post: post, freefeed_client: freefeed_client)

      expect { publisher.publish }.to \
        change { post.reload.slice("state", "freefeed_post_id") }
        .from("state" => "enqueued", "freefeed_post_id" => nil)
        .to("state" => "published", "freefeed_post_id" => "TEST_POST_ID")
    end

    it "publishes attachments" do
      post = create(
        :post,
        feed: feed,
        state: "enqueued",
        attachments: ["https://example.com/image.jpg"],
        comments: []
      )

      # Download attached image
      stub_request(:get, "https://example.com/image.jpg")
        .to_return(
          status: 200,
          body: file_fixture("image_1x1.jpg").read,
          headers: {"Content-Type" => "image/jpeg"}
        )

      # Create attachment
      stub_request(:post, "https://freefeed.test/v1/attachments")
        .to_return(
          status: 200,
          body: {"attachments" => {"id" => "TEST_ATTACHMENT_ID"}}.to_json,
          headers: {
            "Content-Type" => "application/json; charset=utf-8"
          }
        )

      # Create post
      stub_request(:post, "https://freefeed.test/v1/posts")
        .with(
          body: {
            "post" => {
              "body" => "Sample post text",
              "attachments" => ["TEST_ATTACHMENT_ID"]
            },
            "meta" => {
              "feeds" => [feed.name]
            }
          }.to_json,
          headers: json_headers_with_authentication_token
        )
        .to_return(
          status: 200,
          body: {
            "posts" => {
              "id" => "TEST_POST_ID"
            }
          }.to_json,
          headers: {
            "Content-Type" => "application/json; charset=utf-8"
          }
        )

      publisher = described_class.new(post: post, freefeed_client: freefeed_client)

      expect { publisher.publish }.to \
        change { post.reload.slice("state", "freefeed_post_id") }
        .from("state" => "enqueued", "freefeed_post_id" => nil)
        .to("state" => "published", "freefeed_post_id" => "TEST_POST_ID")
    end

    it "publishes comments" do
      post = create(
        :post,
        feed: feed,
        state: "enqueued",
        attachments: [],
        comments: ["Sample comment"]
      )

      # Create post
      stub_request(:post, "https://freefeed.test/v1/posts")
        .with(
          body: {
            "post" => {
              "body" => "Sample post text",
              "attachments" => []
            },
            "meta" => {
              "feeds" => [feed.name]
            }
          }.to_json,
          headers: json_headers_with_authentication_token
        )
        .to_return(
          status: 200,
          body: {
            "posts" => {
              "id" => "TEST_POST_ID"
            }
          }.to_json,
          headers: {
            "Content-Type" => "application/json; charset=utf-8"
          }
        )

      # Create comment
      stub_request(:post, "https://freefeed.test/v1/comments")
        .with(
          body: {comment: {body: "Sample comment", postId: "TEST_POST_ID"}}.to_json,
          headers: json_headers_with_authentication_token
        )
        .to_return(status: 200, body: "", headers: {})

      publisher = described_class.new(post: post, freefeed_client: freefeed_client)

      expect { publisher.publish }.to \
        change { post.reload.slice("state", "freefeed_post_id") }
        .from("state" => "enqueued", "freefeed_post_id" => nil)
        .to("state" => "published", "freefeed_post_id" => "TEST_POST_ID")
    end

    it "handles error response" do
      post = create(
        :post,
        feed: feed,
        state: "enqueued",
        attachments: [],
        comments: []
      )

      # Create post
      stub_request(:post, "https://freefeed.test/v1/posts")
        .with(
          body: {
            "post" => {
              "body" => "Sample post text",
              "attachments" => []
            },
            "meta" => {
              "feeds" => [feed.name]
            }
          }.to_json,
          headers: json_headers_with_authentication_token
        )
        .to_return(status: 500)

      publisher = described_class.new(post: post, freefeed_client: freefeed_client)

      expect { publisher.publish }.to \
        raise_error(Freefeed::Error::InternalServerError).and \
          change { post.reload.slice("state", "freefeed_post_id") }
        .from("state" => "enqueued", "freefeed_post_id" => nil)
        .to("state" => "failed", "freefeed_post_id" => nil)
    end

    it "handles request timeout" do
      post = create(
        :post,
        feed: feed,
        state: "enqueued",
        attachments: [],
        comments: []
      )

      # Create post
      stub_request(:post, "https://freefeed.test/v1/posts")
        .with(
          body: {
            "post" => {
              "body" => "Sample post text",
              "attachments" => []
            },
            "meta" => {
              "feeds" => [feed.name]
            }
          }.to_json,
          headers: json_headers_with_authentication_token
        )
        .to_timeout

      publisher = described_class.new(post: post, freefeed_client: freefeed_client)

      expect { publisher.publish }.to \
        raise_error(HTTP::TimeoutError).and \
          change { post.reload.slice("state", "freefeed_post_id") }
        .from("state" => "enqueued", "freefeed_post_id" => nil)
        .to("state" => "failed", "freefeed_post_id" => nil)
    end
  end
end
