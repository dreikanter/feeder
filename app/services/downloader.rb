class Downloader
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

  MAX_HOPS = 3

  private_constant :MAX_HOPS

  def fetch_url
    HTTP.follow(max_hops: MAX_HOPS).get(url)
  rescue StandardError
    nil
  end
end
