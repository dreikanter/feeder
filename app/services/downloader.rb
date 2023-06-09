class Downloader
  include Callee

  param :url

  def call
    Honeybadger.context(url: url)
    io = StringIO.new
    io.set_encoding(Encoding::BINARY)
    io.write(response.body.to_s)
    io.rewind
    yield io, response.content_type.mime_type
  end

  private

  def response
    @response ||= HTTP.get(url)
  end
end
