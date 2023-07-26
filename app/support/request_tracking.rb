# Usage:
#
#   HTTP.use(:request_tracking).get("https://example.com/")
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
    breadcrumb("HTTP Request Error", request_metadata(request).merge("error" => error.inspect))
  end

  private

  def breadcrumb(message, metadata = {})
    Honeybadger.add_breadcrumb(message, metadata: ensure_primitive_values(metadata), category: "request")
  end

  def ensure_primitive_values(metadata)
    metadata.to_h { [_1.to_s, _2.to_s] }
  end

  # SEE: https://github.com/httprb/http/blob/main/lib/http/request.rb
  def request_metadata(request)
    {
      verb: request.verb,
      uri: request.uri.to_s,
      headers: request.headers.to_h.to_json
    }.as_json
  end

  # SEE: https://github.com/httprb/http/blob/main/lib/http/response.rb
  def response_metadata(response)
    {
      status: response.status,
      headers: response.headers.to_h.to_json,
      version: response.version,
      proxy_headers: response.proxy_headers.to_json
    }.as_json
  end
end
