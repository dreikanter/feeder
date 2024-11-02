RSpec.describe PostPublisher do
  subject(:service) { described_class.new(post: post, freefeed_client: freefeed_client) }

  let(:freefeed_client) do
    Freefeed::Client.new(
      token: "TEST_TOKEN",
      base_url: "https://freefeed.test"
    )
  end

  let(:feed) { create(:feed, name: "sample_feed") }

  describe "#publish" do
    it "publishes a post" do
      post = create(
        :post,
        feed: feed,
        state: "enqueued",
        attachments: [],
        comments: []
      )

      publisher = described_class.new(post: post, freefeed_client: freefeed_client)

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
          headers: {
            "Accept" => "*/*",
            "Authorization" => "Bearer TEST_TOKEN",
            "Connection" => "close",
            "Content-Type" => "application/json; charset=utf-8",
            "Host" => "freefeed.test",
            "User-Agent" => "feeder"
          }
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

      publisher = described_class.new(post: post, freefeed_client: freefeed_client)

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
          headers: {
            "Accept" => "*/*",
            "Authorization" => "Bearer TEST_TOKEN",
            "Connection" => "close",
            "Content-Type" => "application/json; charset=utf-8",
            "Host" => "freefeed.test",
            "User-Agent" => "feeder"
          }
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

      expect { publisher.publish }.to \
        change { post.reload.slice("state", "freefeed_post_id") }
        .from("state" => "enqueued", "freefeed_post_id" => nil)
        .to("state" => "published", "freefeed_post_id" => "TEST_POST_ID")
    end

    it "publishes comments" do
    end

    it "handles error response" do
    end

    it "handles request timeout" do
    end

    it "handles HTTP client exception" do
    end
  end
end
