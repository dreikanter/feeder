class LibredditInstancesFetcher < ServiceInstancesFetcher
  include HttpClient

  # SEE: https://github.com/libreddit/libreddit-instances/tree/master
  SOURCE_URL = "https://raw.githubusercontent.com/libreddit/libreddit-instances/master/instances.json"

  def call
    instances.filter_map { _1["url"] }
  end

  private

  def instances
    JSON.parse(data).fetch("instances")
  rescue StandardError
    []
  end

  def data
    http.get(SOURCE_URL).to_s
  end
end
