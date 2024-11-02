RSpec.describe Freefeed::V1::Posts do
  let(:client) { Freefeed::Client.new(token: "token", base_url: "https://example.com") }

  describe "#create_post" do
    it "creates a post with title only" do
      stub_request(:post, "https://example.com/v1/posts")
        .with(
          body: {title: "New Post"}.to_json,
          headers: {
            "Authorization" => "Bearer token",
            "Content-Type" => "application/json; charset=utf-8",
            "User-Agent" => "feeder"
          }
        )
        .to_return(status: 200, body: "{}")

      response = client.create_post(title: "New Post")

      expect(response.status.code).to eq(200)
    end

    it "creates a post with full parameters" do
      stub_request(:post, "https://example.com/v1/posts")
        .with(
          body: {
            title: "New Post",
            body: "Post content",
            attachments: ["1", "2"],
            feeds: ["feed1", "feed2"],
            commentsDisabled: true
          }.to_json,
          headers: {
            "Authorization" => "Bearer token",
            "Content-Type" => "application/json; charset=utf-8",
            "User-Agent" => "feeder"
          }
        )
        .to_return(status: 200, body: "{}")

      response = client.create_post(
        title: "New Post",
        body: "Post content",
        attachments: ["1", "2"],
        feeds: ["feed1", "feed2"],
        commentsDisabled: true
      )

      expect(response.status.code).to eq(200)
    end
  end

  describe "#delete_post" do
    it "deletes a post" do
      stub_request(:delete, "https://example.com/v1/posts/post-id")
        .with(
          headers: {
            "Authorization" => "Bearer token",
            "User-Agent" => "feeder"
          }
        )
        .to_return(status: 200, body: "{}")

      response = client.delete_post("post-id")

      expect(response.status.code).to eq(200)
    end
  end

  describe "#update_post" do
    it "updates a post" do
      stub_request(:put, "https://example.com/v1/posts/post-id")
        .with(
          body: {
            title: "Updated Title",
            body: "Updated content"
          }.to_json,
          headers: {
            "Authorization" => "Bearer token",
            "Content-Type" => "application/json; charset=utf-8",
            "User-Agent" => "feeder"
          }
        )
        .to_return(status: 200, body: "{}")

      response = client.update_post(
        "post-id",
        title: "Updated Title",
        body: "Updated content"
      )

      expect(response.status.code).to eq(200)
    end
  end

  describe "#hide" do
    it "hides a post" do
      stub_request(:post, "https://example.com/v1/posts/post-id/hide")
        .with(
          headers: {
            "Authorization" => "Bearer token",
            "User-Agent" => "feeder"
          }
        )
        .to_return(status: 200, body: "{}")

      response = client.hide("post-id")

      expect(response.status.code).to eq(200)
    end
  end

  describe "#unhide" do
    it "unhides a post" do
      stub_request(:post, "https://example.com/v1/posts/post-id/unhide")
        .with(
          headers: {
            "Authorization" => "Bearer token",
            "User-Agent" => "feeder"
          }
        )
        .to_return(status: 200, body: "{}")

      response = client.unhide("post-id")

      expect(response.status.code).to eq(200)
    end
  end

  describe "#like" do
    it "likes a post" do
      stub_request(:post, "https://example.com/v1/posts/post-id/like")
        .with(
          headers: {
            "Authorization" => "Bearer token",
            "User-Agent" => "feeder"
          }
        )
        .to_return(status: 200, body: "{}")

      response = client.like("post-id")

      expect(response.status.code).to eq(200)
    end
  end

  describe "#unlike" do
    it "unlikes a post" do
      stub_request(:post, "https://example.com/v1/posts/post-id/unlike")
        .with(
          headers: {
            "Authorization" => "Bearer token",
            "User-Agent" => "feeder"
          }
        )
        .to_return(status: 200, body: "{}")

      response = client.unlike("post-id")

      expect(response.status.code).to eq(200)
    end
  end

  describe "#disable_comments" do
    it "disables comments on a post" do
      stub_request(:post, "https://example.com/v1/posts/post-id/disableComments")
        .with(
          headers: {
            "Authorization" => "Bearer token",
            "User-Agent" => "feeder"
          }
        )
        .to_return(status: 200, body: "{}")

      response = client.disable_comments("post-id")

      expect(response.status.code).to eq(200)
    end
  end

  describe "#enable_comments" do
    it "enables comments on a post" do
      stub_request(:post, "https://example.com/v1/posts/post-id/enableComments")
        .with(
          headers: {
            "Authorization" => "Bearer token",
            "User-Agent" => "feeder"
          }
        )
        .to_return(status: 200, body: "{}")

      response = client.enable_comments("post-id")

      expect(response.status.code).to eq(200)
    end
  end
end
