class UriSanitizer
  DEFAULT_SCHEME = "https".freeze

  attr_reader :uri

  def initialize(uri)
    @uri = uri
  end

  def sanitize
    value = Addressable::URI.parse(uri)
    value.scheme ||= DEFAULT_SCHEME
    value.to_s
  end
end
