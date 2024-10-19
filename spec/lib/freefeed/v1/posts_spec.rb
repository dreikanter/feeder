require "rails_helper"

RSpec.describe Freefeed::V1::Posts do
  let(:client) { Freefeed::Client.new(token: "token", base_url: "https://example.com") }

  it "creates a post" do
    allow(client).to receive(:authenticated_request)
    client.create_post(title: "New Post")
    expect(client).to have_received(:authenticated_request).with(:post, "/v1/posts", json: { title: "New Post" })
  end
end
