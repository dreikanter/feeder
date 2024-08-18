class HttpLoader < BaseLoader
  include HttpClient

  def load
    timestamp = Time.current

    response, import_duration = Stopwatch.measure do
      http.get(feed.url)
    end

    if response.status.success?
      FeedContent.new(
        raw_content: response.to_s,
        imported_at: timestamp,
        import_duration: import_duration
      )
    else
      raise LoaderError, "HTTP request failed"
    end
  end
end
