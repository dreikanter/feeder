class HttpLoader < BaseLoader
  include HttpClient

  Error = Class.new(StandardError)

  def call
    ensure_successful_respone
    response.to_s
  end

  private

  def ensure_successful_respone
    raise Error, "HTTP request failed" unless response.status.success?
  end

  def response
    @response ||= http.get(feed.url)
  end
end
