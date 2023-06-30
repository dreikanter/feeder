class UriSanitizer
  DEFAULT_SCHEME = "https".freeze

  attr_reader :uri

  def initialize(uri)
    @uri = uri
  end

  def sanitize
    Addressable::URI.parse(uri).tap { _1.scheme ||= DEFAULT_SCHEME }.to_s
  end
end
