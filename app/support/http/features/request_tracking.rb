# Usage:
#
#   HTTP.use(request_tracking: {option: value}).get("https://example.com/")
#
class HTTP::Features::RequestTracking < HTTP::Feature
  HTTP::Options.register_feature(:request_tracking, self)

  def initialize(option: nil)
    @option = option
  end

  def wrap_request(request)
    breadcrumb("HTTP Request", request: request.as_json)
    request
  end

  def wrap_response(response)
    breadcrumb("HTTP Response", response: response.as_json)
    response
  end

  def on_error(request, error)
    breadcrumb("HTTP Request Error", request: request.as_json, error: error.as_json)
  end

  private

  def breadcrumb(message, metadata = {})
    Honeybadger.add_breadcrumb(message, metadata: metadata, category: "request")
  end
end
