require "rails_helper"

RSpec.describe Freefeed::Request do
  let(:client) { instance_double("Freefeed::Client", base_url: "https://example.com") }
  let(:options) { { http_max_hops: 3, http_timeout_seconds: 5 } }
  let(:request) { described_class.new(client: client, request_method: :get, path: "/test", options: options) }

  describe "#call" do
    context "when the response is successful" do
      it "makes a HTTP request without raising an error" do
        stub_request(:get, "https://example.com/test").to_return(status: 200, body: "")

        expect { request.call }.not_to raise_error
      end
    end

    context "when the response is unsuccessful" do
      it "raises an error for unsuccessful response" do
        stub_request(:get, "https://example.com/test").to_return(status: 404, body: "")

        expect { request.call }.to raise_error(Freefeed::Error::NotFound)
      end
    end
  end
end
