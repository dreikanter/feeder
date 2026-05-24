require "rails_helper"

RSpec.describe HttpClient do
  let(:client) { Class.new { include HttpClient }.new }
  let(:url) { "https://example.com/feed" }
  let(:body) { "BANANA" }

  before { stub_const("HttpClient::HTTP_CLIENT_RETRY_DELAY", 0) }

  describe "#http_get" do
    it "returns the response on success" do
      stub_request(:get, url).to_return(body: body)
      expect(client.http_get(url).to_s).to eq(body)
    end

    it "retries once on HTTP::TimeoutError and succeeds" do
      stub_request(:get, url).to_raise(HTTP::TimeoutError).then.to_return(body: body)
      expect(client.http_get(url).to_s).to eq(body)
    end

    it "retries once on HTTP::ConnectionError and succeeds" do
      stub_request(:get, url).to_raise(HTTP::ConnectionError).then.to_return(body: body)
      expect(client.http_get(url).to_s).to eq(body)
    end

    it "retries once on OpenSSL::SSL::SSLError and succeeds" do
      stub_request(:get, url).to_raise(OpenSSL::SSL::SSLError).then.to_return(body: body)
      expect(client.http_get(url).to_s).to eq(body)
    end

    it "raises after exhausting retries" do
      stub_request(:get, url).to_raise(HTTP::TimeoutError)
      expect { client.http_get(url) }.to raise_error(HTTP::TimeoutError)
    end

    it "does not retry on non-retryable errors" do
      stub_request(:get, url).to_raise(StandardError)
      expect { client.http_get(url) }.to raise_error(StandardError)
      expect(WebMock).to have_requested(:get, url).once
    end

    it "does not retry on HTTP error status responses" do
      stub_request(:get, url).to_return(status: 500)
      expect(client.http_get(url).status.code).to eq(500)
      expect(WebMock).to have_requested(:get, url).once
    end

    it "honors the attempts argument" do
      stub_request(:get, url).to_raise(HTTP::TimeoutError).then.to_raise(HTTP::TimeoutError).then.to_return(body: body)
      expect(client.http_get(url, attempts: 3).to_s).to eq(body)
    end
  end
end
