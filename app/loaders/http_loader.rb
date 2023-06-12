class HttpLoader < BaseLoader
  protected

  def perform
    ensure_successful_respone
    response.to_s
  end

  private

  def ensure_successful_respone
    return if response.status == 200
    define_error_context
    raise Error
  end

  def define_error_context
    Honeybadger.context(http_loader: {http_response: response.as_json})
  end

  MAX_HOPS = 3

  private_constant :MAX_HOPS

  def response
    @response ||= HTTP.follow(max_hops: MAX_HOPS).get(feed.url)
  end
end
