require "rails_helper"

RSpec.describe RequestTracking do
  subject(:feature) { described_class }

  let(:uri) { "https://example.com/" }

  let(:request) do
    HTTP::Request.new(
      verb: "GET",
      uri: uri,
      headers: {"Content-Type" => "application/json"},
      version: "1.1"
    )
  end

  let(:response) do
    HTTP::Response.new(
      connection: nil,
      request: request,
      status: 200,
      headers: request.headers,
      version: "1.1"
    )
  end

  describe "request processing" do
    let(:expected_request_breadcrumb) do
      [
        "HTTP Request",
        {
          category: "request",
          metadata: {
            verb: "get",
            uri: uri,
            headers: JSON.pretty_generate({"Content-Type" => "application/json", "Host" => "example.com", "User-Agent" => "http.rb/5.1.1"})
          }
        }
      ]
    end

    it "creates breadcrumb on request" do
      expect(Honeybadger).to receive(:add_breadcrumb).with(*expected_request_breadcrumb)
      expect(feature.new.wrap_request(request)).to eq(request)
    end
  end

  describe "Response processing" do
    let(:expected_response_breadcrumb) do
      [
        "HTTP Response",
        {
          category: "request",
          metadata: {
            code: 200,
            headers: JSON.pretty_generate({"Content-Type" => "application/json", "Host" => "example.com", "User-Agent" => "http.rb/5.1.1"}),
            proxy_headers: JSON.pretty_generate({}),
            version: "1.1"
          }
        }
      ]
    end

    it "creates breadcrumb on response" do
      expect(Honeybadger).to receive(:add_breadcrumb).with(*expected_response_breadcrumb)
      expect(feature.new.wrap_response(response)).to eq(response)
    end
  end

  describe "errors processing" do
    let(:expected_error_breadcrumb) do
      [
        "HTTP Request Error",
        {
          category: "request",
          metadata: {
            error: "#<StandardError: sample error>",
            verb: "get",
            uri: uri,
            headers: JSON.pretty_generate({"Content-Type" => "application/json", "Host" => "example.com", "User-Agent" => "http.rb/5.1.1"})
          }
        }
      ]
    end

    it "handle errors" do
      expect(Honeybadger).to receive(:add_breadcrumb).with(*expected_error_breadcrumb)
      feature.new.on_error(request, StandardError.new("sample error"))
    end
  end
end
