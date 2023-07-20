require "rails_helper"

RSpec.describe RequestTracking do
  subject(:feature) { described_class }

  let(:uri) { "https://example.com/" }

  let(:expected_request_breadcrumb) do
    [
      "HTTP Request",
      {
        category: "request",
        metadata: {
          request: {
            "verb" => "get",
            "uri" => uri,
            "headers" => {
              "Connection" => "close",
              "Host" => "example.com",
              "User-Agent" => "http.rb/5.1.1"
            }
          }
        }
      }
    ]
  end

  let(:expected_response_breadcrumb) do
    [
      "HTTP Response",
      {
        category: "request",
        metadata: {
          response: {
            "status" => 200,
            "headers" => {"Content-Type" => "application/json"},
            "proxy_headers" => [],
            "version" => "1.1"
          }
        }
      }
    ]
  end

  it "creates breadcrumbs" do
    stub_request(:get, uri)
      .to_return(
        status: 200,
        body: "{}",
        headers: {"Content-Type" => "application/json"}
      )

    expect(Honeybadger).to receive(:add_breadcrumb).with(*expected_request_breadcrumb)
    expect(Honeybadger).to receive(:add_breadcrumb).with(*expected_response_breadcrumb)
    HTTP.use(:request_tracking).get(uri)
  end

  # TODO: WebMock is not compatible with HTTP errors tracking, need a fix
  # it "handle errors" do
  #   stub_request(:get, uri).to_raise(HTTP::ConnectionError)
  #   expect(Honeybadger).to receive(:add_breadcrumb).with(*expected_request_breadcrumb)
  #   expect(Honeybadger).to receive(:add_breadcrumb).with("HTTP Request Error")
  #   expect { HTTP.use(:request_tracking).get("https://test") }.to raise_error(HTTP::ConnectionError)
  # end
end
