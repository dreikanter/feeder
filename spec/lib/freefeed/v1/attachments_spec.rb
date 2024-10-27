require "rails_helper"

RSpec.describe Freefeed::V1::Attachments do
  let(:client) { Freefeed::Client.new(token: "token", base_url: "https://example.com") }

  describe "#create_attachment" do
    let(:file_path) { "spec/fixtures/image.jpg" }
    let(:content_type) { "image/jpeg" }

    before do
      allow(MimeMagic).to receive(:by_path).with(file_path).and_return(content_type)
    end

    it "uploads a file from path" do
      stub_request(:post, "https://example.com/v1/attachments")
        .with(
          headers: {
            "Authorization" => "Bearer token",
            "User-Agent" => "feeder"
          }
        )
        .to_return(status: 200, body: "{}")

      client.create_attachment(file_path)
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

      client.create_attachment(file_path, content_type: "image/png")
    end

    it "uploads from IO object" do
      io = StringIO.new("fake image content")
      allow(MimeMagic).to receive(:by_magic).with(io).and_return(content_type)

      stub_request(:post, "https://example.com/v1/attachments")
        .with(
          headers: {
            "Authorization" => "Bearer token",
            "User-Agent" => "feeder"
          }
        )
        .to_return(status: 200, body: "{}")

      client.create_attachment(io)
    end
  end

  describe "#create_attachment_from" do
    let(:downloader) { instance_double(Freefeed::Downloader) }
    let(:remote_url) { "https://example.com/image.jpg" }
    let(:attachment_response) do
      {
        "attachments" => {
          "id" => "attachment-123"
        }
      }.to_json
    end

    it "creates attachment from remote URL" do
      allow(Freefeed::Downloader).to receive(:new)
        .with(url: remote_url, http_client: client.send(:http_client))
        .and_return(downloader)

      expect(downloader).to receive(:call) do |&block|
        io = StringIO.new("fake image content")
        block.call(io, "image/jpeg")
      end

      stub_request(:post, "https://example.com/v1/attachments")
        .with(
          headers: {
            "Authorization" => "Bearer token",
            "User-Agent" => "feeder"
          }
        )
        .to_return(status: 200, body: attachment_response)

      result = client.create_attachment_from(url: remote_url)
      expect(result).to eq("attachment-123")
    end
  end
end
