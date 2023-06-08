class RedditPointsFetcher
  include Callee

  param :url

  def call
    Integer(dom.css('.post_score').attribute('title').value)
  end

  private

  def dom
    Nokogiri::HTML(page_content)
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

  def page_content
    RestClient.get(libreddit_url).body
  end

  def libreddit_url
    URI.parse(short_url).tap { |parsed| parsed.host = LIBREDDIT_HOSTS.sample }.to_s
  end

  def short_url
    RedditSlugsChopper.call(url)
  end
end
