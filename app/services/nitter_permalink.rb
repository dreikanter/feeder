class NitterPermalink
  include Callee

  param :url

  TWITTER_HOST = 'twitter.com'.freeze

  def call
    URI.parse(url).tap { |uri| uri.host = TWITTER_HOST }.to_s
  end
end
