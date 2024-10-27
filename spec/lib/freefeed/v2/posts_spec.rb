require "rails_helper"

RSpec.describe Freefeed::V2::Posts do
  let(:client) { Freefeed::Client.new(token: "token", base_url: "https://example.com") }

  describe "#post" do
    it "gets a post by id" do
      stub_request(:get, "https://example.com/v2/posts/post-123")
        .with(
          headers: {
            "Authorization" => "Bearer token",
            "User-Agent" => "feeder"
          }
        )
        .to_return(status: 200, body: "{}")

      response = client.post("post-123")

      expect(response.status.code).to eq(200)
    end
  end

  describe "#post_open_graph" do
    it "gets open graph data for a post" do
      stub_request(:get, "https://example.com/v2/posts-opengraph/post-123")
        .with(
          headers: {
            "Authorization" => "Bearer token",
            "User-Agent" => "feeder"
          }
        )
        .to_return(status: 200, body: "{}")

      response = client.post_open_graph("post-123")

      expect(response.status.code).to eq(200)
    end
  end
end
