class Downloader
  include Callee

  param :url

  def call
    io = StringIO.new
    io.set_encoding(Encoding::BINARY)
    io.write(response.body)
    io.rewind
    yield io, response.headers[:content_type]
  rescue StandardError
    raise "error downloading url: '#{url}'"
  end

  private

  def response
    @response ||= RestClient.get(url)
  end
end
