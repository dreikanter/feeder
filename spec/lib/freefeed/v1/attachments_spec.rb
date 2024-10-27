require "rails_helper"

RSpec.describe Freefeed::V1::Attachments do
  let(:client) { Freefeed::Client.new(token: "token", base_url: "https://example.com") }

  describe "#create_attachment" do
    let(:file_path) { file_fixture("image_1x1.jpg") }

    it "uploads a file from path" do
      stub_request(:post, "https://example.com/v1/attachments")
        .with(
          headers: {
            "Authorization" => "Bearer token",
            "User-Agent" => "feeder"
          }
        )
        .to_return(status: 200, body: "{}")

      response = client.create_attachment(file_path)

      expect(response.status.code).to eq(200)
    end

    it "uploads a file with explicit content type" do
      stub_request(:post, "https://example.com/v1/attachments")
        .with(
          headers: {
            "Authorization" => "Bearer token",
            "User-Agent" => "feeder"
          }
        )
        .to_return(status: 200, body: "{}")

      response = client.create_attachment(file_path, content_type: "image/png")

      expect(response.status.code).to eq(200)
    end

    it "uploads from IO object" do
      stub_request(:post, "https://example.com/v1/attachments")
        .with(
          headers: {
            "Authorization" => "Bearer token",
            "User-Agent" => "feeder"
          }
        )
        .to_return(status: 200, body: "{}")

      io = StringIO.new("fake image content")
      response = client.create_attachment(io)

      expect(response.status.code).to eq(200)
    end
  end

  describe "#create_attachment_from" do
    let(:remote_url) { "https://example.com/image.jpg" }
    let(:attachment_response) do
      {
        "attachments" => {
          "id" => "attachment-123"
        }
      }.to_json
    end

    it "creates attachment from remote URL" do
      # Stub the remote image download
      stub_request(:get, remote_url)
        .to_return(
          status: 200,
          body: "fake image content",
          headers: {"Content-Type" => "image/jpeg"}
        )

      # Stub the attachment creation
      stub_request(:post, "https://example.com/v1/attachments")
        .with(
          headers: {
            "Authorization" => "Bearer token",
            "User-Agent" => "feeder"
          }
        )
        .to_return(
          status: 200,
          body: attachment_response,
          headers: {"Content-Type" => "application/json"}
        )

      result = client.create_attachment_from(url: remote_url)

      expect(result).to eq("attachment-123")
    end
  end
end
