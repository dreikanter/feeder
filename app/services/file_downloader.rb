class FileDownloader
  include Callee

  param :url

  def call
    Tempfile.open("download-#{SecureRandom.uuid}", binmode: true) do |file|
      file.write(response.body)
      file.rewind
      yield file, response.headers[:content_type]
    end
  end

  def response
    @response ||= RestClient.get(url)
  end
end
