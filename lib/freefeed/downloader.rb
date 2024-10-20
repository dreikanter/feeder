module Freefeed
  class Downloader
    attr_reader :url

    def initialize(url:, max_hops: 3, timeout_seconds: 5)
      @url = url
      @max_hops = max_hops
      @timeout_seconds = timeout_seconds
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
      http.get(url)
    rescue StandardError
      # TBD: Report download error
      nil
    end

    def http
      HTTP
        .use(:request_tracking)
        .follow(max_hops: max_hops)
        .timeout(timeout_seconds)
    end
  end
end
