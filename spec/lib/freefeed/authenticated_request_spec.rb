require "rails_helper"

RSpec.describe Freefeed::AuthenticatedRequest do
  let(:client) do
    Freefeed::Client.new(
      token: "TEST_TOKEN",
      base_url: "https://example.com",
      http_client: HTTP
    )
  end

  describe "#perform" do
    context "when the response is successful" do
      it "makes a HTTP request without raising an error" do
        stub_request(:post, "https://example.com/test")
          .with(
            body: {payload: "data"}.to_json,
            headers: {
              "Authorization" => "Bearer TEST_TOKEN",
              "Content-Type" => "application/json; charset=utf-8",
              "User-Agent" => "feeder"
            }
          )
          .to_return(
            status: 200,
            headers: {"Content-Type" => "application/json"},
            body: {"response" => "payload"}.to_json
          )

        request = described_class.new(
          client: client,
          request_method: :post,
          path: "/test",
          payload: {json: {"payload" => "data"}}
        )

        actual = request.perform.parse
        expected = {"response" => "payload"}

        assert_equal expected, actual
      end
    end
  end
end
