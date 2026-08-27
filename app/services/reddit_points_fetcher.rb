class RedditPointsFetcher
  include HttpClient

  Error = Class.new(StandardError)

  attr_reader :url

  def initialize(url)
    @url = url
  end

  def points
    Integer(extract_post_score)
  end

  private

  # NOTE: A response without a post score means the instance served something
  #   other than the requested page (an anti-bot challenge or an error page
  #   under a 2xx status). It counts as an instance error, so a broken instance
  #   gets suspended instead of silently draining every Reddit feed it serves.
  # :reek:TooManyStatements
  def extract_post_score
    score = LibredditContent.post_score(page_content)
    raise Error, "libreddit returned no post score for #{libreddit_url}" if score.blank?
    score
  rescue StandardError
    service_instance.register_error
    raise
  end

  # :reek:TooManyStatements
  def page_content
    service_instance.update!(used_at: Time.current, usages_count: service_instance.usages_count.succ)
    response = http_get(libreddit_url)
    status = response.status
    raise Error, "libreddit returned #{status} for #{libreddit_url}" unless status.success?
    response.to_s
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
