require "rails_helper"

RSpec.describe HttpLoader do
  subject(:load_content) { described_class.new(feed).content }

  let(:feed) { build(:feed) }
  let(:content) { "BANANA" }
  let(:arbitrary_error) { "arbitrary error object" }
  let(:redirect_url) { "https://example.com/redirect" }

  it "requires feed url to present" do
    feed.url = nil
    expect { load_content }.to raise_error(HTTP::Error)
  end

  it "requires explicit scheme" do
    feed.url = URI.parse(feed.url).tap { |parsed| parsed.scheme = nil }.to_s
    expect { load_content }.to raise_error(HTTP::Error)
  end

  it "returns successful response body" do
    stub_request(:get, feed.url).to_return(body: content)
    expect(load_content).to eq(content)
  end

  it "raises on error response" do
    stub_request(:get, feed.url).to_return(status: 404)
    expect { load_content }.to raise_error(StandardError)
  end

  it "passes request execution errors" do
    stub_request(:get, feed.url).to_raise(arbitrary_error)
    expect { load_content }.to raise_error(arbitrary_error)
  end

  it "follows redirects" do
    stub_get_request_with_redirects(feed.url, hops: 2)
    expect(load_content).to eq(content)
  end

  it "raises if too many redirects" do
    stub_get_request_with_redirects(feed.url, hops: 4)
    expect { load_content }.to raise_error(HTTP::Redirector::TooManyRedirectsError)
  end

  def stub_get_request_with_redirects(url, hops:)
    hops.times do |hop|
      redirect_from = hop.zero? ? url : "#{redirect_url}#{hop}"
      stub_request(:get, redirect_from).to_return(status: 301, headers: {"Location" => "#{redirect_url}#{hop.succ}"})
    end

    stub_request(:get, "#{redirect_url}#{hops}").to_return(body: content)
  end
end
