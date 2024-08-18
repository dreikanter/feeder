require "rails_helper"

RSpec.describe HttpLoader do
  subject(:service) { described_class }

  let(:feed) { build(:feed) }
  let(:content) { file_fixture("sample_rss.xml").read }

  before { freeze_time }

  describe "#load" do
    context "when on the happy path" do
      it "loads content" do
        stub_request(:get, feed.url).to_return(body: content)

        expected = FeedContent.new(
          raw_content: content,
          imported_at: Time.current,
          import_duration: 0.0
        )

        expect(service.new(feed).load).to eq(expected)
      end
    end

    context "when HTTP request fails" do
      it "raises an error" do
        stub_request(:get, feed.url).to_return(status: 404)

        expect { service.new(feed).load }.to raise_error(LoaderError)
      end
    end

    context "when URL is missing" do
      it "raises an error" do
        feed.url = nil

        expect { service.new(feed).load }.to raise_error(HTTP::Error)
      end
    end

    context "when URL schema is missing" do
      it "raises an error" do
        feed.url = "example.com/rss"

        expect { service.new(feed).load }.to raise_error(HTTP::Error)
      end
    end

    context "when server responds with a redirect" do
      it "follows redirects" do
        stub_get_request_with_redirects(feed.url, hops: 2, content: content)

        expect(service.new(feed).load).to be_a(FeedContent)
      end
    end

    it "raises if too many redirects" do
      stub_get_request_with_redirects(feed.url, hops: 4, content: content)

      expect { service.new(feed).load }.to raise_error(HTTP::Redirector::TooManyRedirectsError)
    end
  end

  def stub_get_request_with_redirects(url, hops:, content:)
    hops.times do |hop|
      redirect_from = hop.zero? ? url : redirect_url(hop)
      headers = {"Location" => redirect_url(hop.succ)}
      stub_request(:get, redirect_from).to_return(status: 301, headers: headers)
    end

    stub_request(:get, redirect_url(hops)).to_return(body: content)
  end

  def redirect_url(index)
    "https://example.com/redirect/#{index}"
  end
end
