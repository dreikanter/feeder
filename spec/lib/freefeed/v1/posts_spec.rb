require "rails_helper"

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

      client.create_post(title: "New Post")
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

      client.create_post(
        title: "New Post",
        body: "Post content",
        attachments: ["1", "2"],
        feeds: ["feed1", "feed2"],
        commentsDisabled: true
      )
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

      client.delete_post("post-id")
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

      client.update_post(
        "post-id",
        title: "Updated Title",
        body: "Updated content"
      )
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

      client.hide("post-id")
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

      client.unhide("post-id")
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

      client.like("post-id")
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

      client.unlike("post-id")
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

      client.disable_comments("post-id")
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

      client.enable_comments("post-id")
    end
  end
end
