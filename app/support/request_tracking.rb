# Usage:
#
#   HTTP.use(:request_tracking).get("https://example.com/")
#
# SEE: https://github.com/httprb/http/blob/main/lib/http/request.rb
# SEE: https://github.com/httprb/http/blob/main/lib/http/response.rb
#
class RequestTracking < HTTP::Feature
  HTTP::Options.register_feature(:request_tracking, self)

  def wrap_request(request)
    Honeybadger.add_breadcrumb(
      "HTTP Request",
      category: "request",
      metadata: {
        verb: request.verb.to_s,
        uri: request.uri.to_s,
        headers: request.headers.to_h.to_json
      }
    )

    request
  end

  def wrap_response(response)
    Honeybadger.add_breadcrumb(
      "HTTP Response",
      category: "request",
      metadata: {
        status: response.status.to_s,
        headers: response.headers.to_h.to_json,
        version: response.version.to_s,
        proxy_headers: response.proxy_headers.to_json
      }
    )

    response
  end

  def on_error(request, error)
  Honeybadger.add_breadcrumb(
      "HTTP Request Error",
      category: "request",
      metadata: {
        error: error.inspect,
        verb: request.verb.to_s,
        uri: request.uri.to_s,
        headers: request.headers.to_h.to_json
      }
    )
  end
end
