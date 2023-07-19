# Usage:
#
#   HTTP.use(:request_tracking).get("https://example.com/")
#
class RequestTracking < HTTP::Feature
  HTTP::Options.register_feature(:request_tracking, self)

  def wrap_request(request)
    breadcrumb("HTTP Request", request: request_data(request))
    request
  end

  def wrap_response(response)
    breadcrumb("HTTP Response", response: response_data(response))
    response
  end

  # TODO: Figure out why HTTP ignores this method
  def on_error(request, error)
    breadcrumb("HTTP Request Error", request: request_data(request), error: error.as_json)
  end

  private

  def breadcrumb(message, metadata = {})
    Honeybadger.add_breadcrumb(message, metadata: metadata, category: "request")
  end

  def request_data(request)
    {
      verb: request.verb,
      uri: request.uri.to_s,
      headers: request.headers.to_h,
      body_size: request.body.size
    }.as_json
  end

  def response_data(response)
    response.as_json.except("request").tap do |data|
      data["headers"] = data["headers"].to_h
    end
  end
end
