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
    breadcrumb("HTTP Request", request_metadata(request))
    request
  end

  def wrap_response(response)
    breadcrumb("HTTP Response", response_metadata(response))
    response
  end

  def on_error(request, error)
    breadcrumb("HTTP Request Error", request_metadata(request).merge(error: error.inspect))
  end

  private

  def breadcrumb(message, metadata)
    Honeybadger.add_breadcrumb(message, category: "request", metadata: metadata)
  end

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
