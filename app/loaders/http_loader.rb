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
    Honeybadger.context(http_response: response.as_json)
  end

  def response
    @response ||= HTTP.get(feed.url)
  end
end
