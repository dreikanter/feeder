class NitterPermalink
  include Callee

  param :url

  def call
    URI.parse(url).tap do |parsed|
      parsed.host = "twitter.com"
      parsed.scheme = "https"
    end.to_s
  end
end
