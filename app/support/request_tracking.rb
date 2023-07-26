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
    Honeybadger.add_breadcrumb("HTTP Request", category: "request", metadata: request_metadata(request))
    request
  end

  def wrap_response(response)
    Honeybadger.add_breadcrumb("HTTP Response", category: "request", metadata: response_metadata(response))
    response
  end

  def on_error(request, error)
    Honeybadger.add_breadcrumb("HTTP Request Error", category: "request", metadata: request_metadata(request).merge(error: error.inspect))
  end

  private

  def request_metadata(request)
    {
      verb: request.verb.to_s,
      uri: request.uri.to_s,
      headers: JSON.pretty_generate(request.headers.to_h)
    }
  end

  def response_metadata(response)
    {
      code: response.status.code,
      headers: JSON.pretty_generate(response.headers.to_h),
      version: response.version.to_s,
      proxy_headers: JSON.pretty_generate(response.proxy_headers.to_h)
    }
  end
end
