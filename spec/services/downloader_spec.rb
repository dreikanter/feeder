require "rails_helper"

RSpec.describe Downloader do
  subject(:service) { described_class }

  let(:url) { "https://placehold.it/1x1.png" }
  let(:expected_content_type) { "image/png" }

  let(:expected_io) do
    StringIO.new(binary_image_data.read).tap do |io|
      # Otherwise it would be UTF-8
      io.set_encoding(Encoding::BINARY)
    end
  end

  let(:binary_image_data) { file_fixture("1x1.png") }
  let(:non_ascii_url) { "https://example.com/bürger.png" }
  let(:redirect_url) { "https://example.com/1x1.png" }
  let(:unparseable_urls) { [nil, "", "+&://WЯONG"] }

  it "downloads stuff" do
    stub_request_with_image(url)

    service.call(url) do |io, content_type|
      expect(expected_io.read).to eq(io.read)
      expect(expected_content_type).to eq(content_type)
    end
  end

  it "accepts non-ascii urls" do
    stub_request_with_image(non_ascii_url)

    service.call(non_ascii_url) do |io, content_type|
      expect(expected_io.read).to eq(io.read)
      expect(expected_content_type).to eq(content_type)
    end
  end

  it "follows redirects" do
    stub_request(:get, url).to_return(status: 301, headers: {"Location" => redirect_url})
    stub_request_with_image(redirect_url)

    expect { |block| service.call(url, &block) }.to yield_control

    service.call(url) do |io, content_type|
      expect(expected_io.read).to eq(io.read)
      expect(expected_content_type).to eq(content_type)
    end
  end

  it "does not yield on error" do
    stub_request(:get, url).to_return(status: 404)
    expect { |block| service.call(url, &block) }.not_to yield_control
  end

  it "does not yield when too many redirects" do
    stub_request(:get, url).to_return(status: 301, headers: {"Location" => "http://example.com/1"})
    stub_request(:get, "http://example.com/1").to_return(status: 301, headers: {"Location" => "https://example.com/2"})
    stub_request(:get, "https://example.com/2").to_return(status: 301, headers: {"Location" => url})
    expect { |block| service.call(url, &block) }.not_to yield_control
  end

  it "does not yield when bad URL" do
    unparseable_urls.each do |unparseable_url|
      expect { |block| service.call(unparseable_url, &block) }.not_to yield_control
    end
  end

  def stub_request_with_image(image_url)
    stub_request(:get, image_url)
      .to_return(
        headers: {"Content-Type" => expected_content_type},
        body: binary_image_data
      )
  end
end
