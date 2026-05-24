class SourceFaultyLoader < BaseLoader
  def content
    raise OpenSSL::SSL::SSLError, "SSL handshake failed"
  end
end
