class RedditPointsFetcher
  include HttpClient

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
    service_instance.update!(used_at: Time.current, usages_count: service_instance.usages_count.succ)
    response = http.get(libreddit_url)
    raise unless response.status.success?
    response.to_s
  rescue StandardError
    service_instance.register_error
    raise
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

  def service_instance
    @service_instance ||= ServiceInstance.pick!("libreddit")
  end
end
