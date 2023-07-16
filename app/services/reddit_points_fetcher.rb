class RedditPointsFetcher
  Error = Class.new(StandardError)

  attr_reader :url

  def initialize(url)
    @url = url
  end

  def points
    Integer(extract_post_score)
  end

  private

  def extract_post_score
    Nokogiri::HTML(page_content).css(".post_score").attribute("title").value
  end

  # :reek:TooManyStatements
  def page_content
    response = HTTP.timeout(5).follow(max_hops: 3).get(libreddit_url)
    raise unless response.code == 200
    response.to_s
  rescue StandardError
    register_service_instance_error
    Honeybadger.context(reddit_points_fetcher: {response: response&.as_json, service_instance: service_instance.as_json, libreddit_url: libreddit_url})
    raise
  end

  def register_service_instance_error
    service_instance.fail! if service_instance.persisted? && service_instance.may_fail?
  end

  def libreddit_url
    URI.parse(short_url).tap { |parsed| parsed.host = libreddit_host }.to_s
  end

  def libreddit_host
    URI.parse(service_instance.url).host
  end

  def short_url
    RedditSlugsChopper.call(url)
  end

  DEFAULT_INSTANCE = "https://safereddit.com"

  private_constant :DEFAULT_INSTANCE

  def service_instance
    @service_instance ||= ServiceInstance.pick("libreddit") || ServiceInstance.new(url: DEFAULT_INSTANCE)
  end
end
