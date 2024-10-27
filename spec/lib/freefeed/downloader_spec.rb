require "rails_helper"

RSpec.describe Freefeed::Downloader do
  let(:url) { "https://example.com/image.jpg" }
  let(:http_client) { HTTP }
  let(:downloader) { described_class.new(url: url, http_client: http_client) }
  let(:binary_content) { File.read("spec/fixtures/files/image_1x1.jpg", mode: "rb") }

  describe "successful download" do
    before do
      stub_request(:get, url)
        .to_return(
          status: 200,
          body: binary_content,
          headers: {"Content-Type" => "image/jpeg"}
        )
    end

    it "yields IO object and content type" do
      expect { |b| downloader.call(&b) }
        .to yield_with_args(instance_of(StringIO), "image/jpeg")
    end

    it "downloads file with correct content" do
      downloader.call do |io, mime_type|
        expect(mime_type).to eq("image/jpeg")
        expect(io.read).to eq(binary_content)
      end
    end

    it "rewinds IO object before yielding" do
      downloader.call do |io, _mime_type|
        expect(io.pos).to eq(0)
      end
    end

    it "sets binary encoding for IO object" do
      downloader.call do |io, _mime_type|
        expect(io.external_encoding).to eq(Encoding::BINARY)
      end
    end
  end

  describe "missing content type" do
    before do
      stub_request(:get, url)
        .to_return(
          status: 200,
          body: binary_content,
          headers: {}
        )
    end

    it "yields IO object and nil content type" do
      downloader.call do |io, mime_type|
        expect(mime_type).to be_nil
        expect(io.read).to eq(binary_content)
      end
    end
  end

  describe "network failures" do
    it "returns nil on connection error" do
      stub_request(:get, url).to_raise(HTTP::ConnectionError)

      expect { |b| downloader.call(&b) }.not_to yield_control
      expect(downloader.call {}).to be_nil
    end

    it "returns nil on timeout error" do
      stub_request(:get, url).to_raise(HTTP::TimeoutError)

      expect { |b| downloader.call(&b) }.not_to yield_control
      expect(downloader.call {}).to be_nil
    end
  end

  describe "error status codes" do
    [403, 404, 500].each do |status|
      it "returns nil for status #{status}" do
        stub_request(:get, url).to_return(status: status)

        expect { |b| downloader.call(&b) }.not_to yield_control
        expect(downloader.call {}).to be_nil
      end
    end
  end

  describe "content types" do
    {
      "image/png" => "image.png",
      "application/pdf" => "document.pdf",
      "text/plain" => "text.txt",
      "application/octet-stream" => "binary.dat"
    }.each do |mime_type, filename|
      it "handles #{mime_type} content type" do
        stub_request(:get, "https://example.com/#{filename}")
          .to_return(
            status: 200,
            body: binary_content,
            headers: {"Content-Type" => mime_type}
          )

        downloader = described_class.new(
          url: "https://example.com/#{filename}",
          http_client: http_client
        )

        downloader.call do |io, content_type|
          expect(content_type).to eq(mime_type)
          expect(io.read).to eq(binary_content)
        end
      end
    end
  end

  describe "empty response" do
    before do
      stub_request(:get, url)
        .to_return(
          status: 200,
          body: "",
          headers: {"Content-Type" => "text/plain"}
        )
    end

    it "handles empty response correctly" do
      downloader.call do |io, mime_type|
        expect(mime_type).to eq("text/plain")
        expect(io.read).to eq("")
      end
    end
  end
end
