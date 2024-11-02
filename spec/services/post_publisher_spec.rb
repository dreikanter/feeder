RSpec.describe PostPublisher do
  subject(:service) { described_class.new(post: post, freefeed_client: freefeed_client) }

  let(:freefeed_client) do
    Freefeed::Client.new(
      token: "TEST_TOKEN",
      base_url: "https://freefeed.test"
    )
  end

  describe "#publish" do
    it "publishes a post" do
      post = create(:post, state: "enqueued", attachments: [], comments: [])
      publisher = described_class.new(post: post, freefeed_client: freefeed_client)

      stub_request(:post, "https://freefeed.test/v1/posts")
        .with(
          body: {
            "post" => {
              "body" => "Sample post text",
              "attachments" => []
            },
            "meta" => {
              "feeds" => ["sample"]
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

      expect { publisher.publish }.to change { post.reload.slice("state", "freefeed_post_id") }.
        from("state" => "enqueued", "freefeed_post_id" => nil).
        to("state" => "published", "freefeed_post_id" => "TEST_POST_ID")
    end
  end
end
