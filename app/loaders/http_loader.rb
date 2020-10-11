class HttpLoader < BaseLoader
  # TODO: Rename client to fetcher
  option(
    :client,
    optional: true,
    default: -> { ->(url) { RestClient.get(url).body } }
  )

  protected

  def perform
    client.call(feed.url)
  end
end
