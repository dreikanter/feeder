class Downloader
  include HttpClient
  include Callee

  param :url

  def call
    Honeybadger.context(downloader: {url: url})
    response = fetch_url
    return unless response&.status&.success?
    yield build_io_from(response), response.content_type.mime_type
  end

  private

  def build_io_from(response)
    StringIO.new.tap do |io|
      io.set_encoding(Encoding::BINARY)
      io.write(response.body.to_s)
      io.rewind
    end
  end

  def fetch_url
    http.get(url)
  rescue StandardError
    nil
  end
end
