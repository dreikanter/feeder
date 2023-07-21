class HttpLoader < BaseLoader
  include HttpClient

  def call
    ensure_successful_respone
    response.to_s
  end

  private

  def ensure_successful_respone
    raise Error unless response.status.success?
  end

  def response
    @response ||= http.get(feed.url)
  end
end
