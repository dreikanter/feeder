require "rails_helper"

RSpec.describe Freefeed::Request do
  let(:base_url) { "https://example.com" }
  let(:http_client) { HTTP }

  describe "#perform" do
    context "when the response is successful" do
      it "makes a HTTP request without raising an error" do
        stub_request(:post, "https://example.com/test")
          .with(
            body: {payload: "data"}.to_json,
            headers: {
              "Content-Type" => "application/json; charset=utf-8",
              "Host" => "example.com",
              "User-Agent" => "feeder"
            }
          )
          .to_return(
            status: 200,
            headers: {"Content-Type" => "application/json"},
            body: {"response" => "payload"}.to_json
          )

        request = described_class.new(
          http_client: http_client,
          base_url: base_url,
          request_method: :post,
          path: "/test",
          payload: {json: {"payload" => "data"}}
        )

        actual = request.perform.parse
        expected = {"response" => "payload"}

        assert_equal expected, actual
      end
    end

    context "when the response is unsuccessful" do
      it "raises an error for unsuccessful response" do
        stub_request(:get, "https://example.com/test").to_return(status: 404)

        request = described_class.new(
          http_client: http_client,
          base_url: base_url,
          request_method: :get,
          path: "/test"
        )

        expect { request.perform }.to raise_error(Freefeed::Error::NotFound)
      end
    end
  end
end
