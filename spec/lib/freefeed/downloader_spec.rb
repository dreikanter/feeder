require "rails_helper"

RSpec.describe Freefeed::Downloader do
  let(:url) { "https://example.com/image.jpg" }
  let(:http_client) { HTTP }
  let(:downloader) { described_class.new(url: url, http_client: http_client) }
  let(:binary_content) { File.read("spec/fixtures/files/test_1x1.jpg", mode: "rb") }

  describe "#call" do
    context "when download is successful" do
      before do
        stub_request(:get, url)
          .to_return(
            status: 200,
            body: binary_content,
            headers: { "Content-Type" => "image/jpeg" }
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

    context "when response is missing content type" do
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

    context "when download fails" do
      context "with network error" do
        before do
          stub_request(:get, url).to_raise(HTTP::ConnectionError)
        end

        it "returns nil without yielding" do
          expect { |b| downloader.call(&b) }.not_to yield_control
          expect(downloader.call {}).to be_nil
        end
      end

      context "with timeout error" do
        before do
          stub_request(:get, url).to_raise(HTTP::TimeoutError)
        end

        it "returns nil without yielding" do
          expect { |b| downloader.call(&b) }.not_to yield_control
          expect(downloader.call {}).to be_nil
        end
      end

      context "with non-success status code" do
        [403, 404, 500].each do |status|
          context "when status is #{status}" do
            before do
              stub_request(:get, url).to_return(status: status)
            end

            it "returns nil without yielding" do
              expect { |b| downloader.call(&b) }.not_to yield_control
              expect(downloader.call {}).to be_nil
            end
          end
        end
      end
    end

    context "with different content types" do
      {
        "image/png" => "image.png",
        "application/pdf" => "document.pdf",
        "text/plain" => "text.txt",
        "application/octet-stream" => "binary.dat"
      }.each do |mime_type, filename|
        context "when content type is #{mime_type}" do
          let(:url) { "https://example.com/#{filename}" }

          before do
            stub_request(:get, url)
              .to_return(
                status: 200,
                body: binary_content,
                headers: { "Content-Type" => mime_type }
              )
          end

          it "correctly handles #{mime_type} content type" do
            downloader.call do |io, content_type|
              expect(content_type).to eq(mime_type)
              expect(io.read).to eq(binary_content)
            end
          end
        end
      end
    end

    context "with empty response" do
      before do
        stub_request(:get, url)
          .to_return(
            status: 200,
            body: "",
            headers: { "Content-Type" => "text/plain" }
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
end
