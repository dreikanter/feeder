require "rails_helper"

RSpec.describe Freefeed::V1::Comments do
  let(:client) { Freefeed::Client.new(token: "token", base_url: "https://example.com") }

  describe "#create_comment" do
    it "creates a comment" do
      stub_request(:post, "https://example.com/v1/comments")
        .with(
          body: {
            body: "Comment text",
            postId: "post-123"
          }.to_json,
          headers: {
            "Authorization" => "Bearer token",
            "Content-Type" => "application/json; charset=utf-8",
            "User-Agent" => "feeder"
          }
        )
        .to_return(status: 200, body: "{}")

      response = client.create_comment(
        body: "Comment text",
        postId: "post-123"
      )
      expect(response.status.code).to eq(200)
    end
  end

  describe "#update_comment" do
    it "updates a comment" do
      stub_request(:put, "https://example.com/v1/comments/comment-123")
        .with(
          body: {
            body: "Updated comment text"
          }.to_json,
          headers: {
            "Authorization" => "Bearer token",
            "Content-Type" => "application/json; charset=utf-8",
            "User-Agent" => "feeder"
          }
        )
        .to_return(status: 200, body: "{}")

      response = client.update_comment(
        "comment-123",
        body: "Updated comment text"
      )
      expect(response.status.code).to eq(200)
    end
  end

  describe "#delete_comment" do
    it "deletes a comment" do
      stub_request(:delete, "https://example.com/v1/comments/comment-123")
        .with(
          headers: {
            "Authorization" => "Bearer token",
            "User-Agent" => "feeder"
          }
        )
        .to_return(status: 200, body: "{}")

      response = client.delete_comment("comment-123")
      expect(response.status.code).to eq(200)
    end
  end
end
