class HttpLoader < BaseLoader
  protected

  def perform
    RestClient.get(feed.url).body
  end
end
