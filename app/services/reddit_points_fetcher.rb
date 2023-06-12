class RedditPointsFetcher
  Error = Class.new(StandardError)

  include Callee

  param :url

  def call
    Integer(dom.css(".post_score").attribute("title").value)
  end

  private

  def dom
    Nokogiri::HTML(page_content)
  end

  def page_content
    ensure_successful_respone
    response.to_s
  end

  def ensure_successful_respone
    return if response.status == 200
    define_error_context
    raise Error
  end

  def define_error_context
    Honeybadger.context(
      reddit_points_fetcher: {
        libreddit_host: libreddit_host,
        short_url: short_url,
        libreddit_url: libreddit_url
      }
    )
  end

  LIBREDDIT_HOSTS = %w[
    safereddit.com
    libreddit.kavin.rocks
    lr.riverside.rocks
    reddit.baby
    libreddit.de
    libreddit.hu
    libreddit.nl
  ].freeze

  private_constant :LIBREDDIT_HOSTS

  MAX_HOPS = 3

  private_constant :MAX_HOPS

  def response
    @response ||= HTTP.follow(max_hops: MAX_HOPS).get(libreddit_url)
  end

  def libreddit_url
    URI.parse(short_url).tap { |parsed| parsed.host = libreddit_host }.to_s
  end

  def libreddit_host
    @libreddit_host ||= LIBREDDIT_HOSTS.sample
  end

  def short_url
    RedditSlugsChopper.call(url)
  end
end
