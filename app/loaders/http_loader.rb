class HttpLoader < BaseLoader
  include HttpClient

  Error = Class.new(StandardError)

  def content
    return response.to_s if response.status.success?
    raise Error, "HTTP request failed"
  end

  private

  def response
    @response ||= http.get(feed.url)
  end
end
