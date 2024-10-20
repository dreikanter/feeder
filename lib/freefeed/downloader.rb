module Freefeed
  class Downloader
    attr_reader :url, :http_client

    def initialize(url:, http_client: nil)
      @url = url
      @http_client = http_client
    end

    def call
      # TBD: Honeybadger.context(downloader: {url: url})
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
      http_client.get(url)
    rescue StandardError
      # TBD: Report download error
      nil
    end
  end
end
