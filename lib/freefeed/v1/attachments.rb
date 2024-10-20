module Freefeed
  module V1
    module Attachments
      # @param [String, Pathname, IO] source could by a file path
      # or an IO object
      def create_attachment(source, content_type: nil)
        payload = {form: {file: file(source, content_type)}}
        authenticated_request(:post, "/v1/attachments", payload)
      end

      def create_attachment_from(url:, **)
        ::Freefeed::Downloader.new(url: url, http_client: http_client, **).call do |io, content_type|
          response = create_attachment(io, content_type: content_type)
          response.parse.fetch("attachments").fetch("id")
        end
      end

      private

      def file(source, content_type)
        content_type ||= detect_content_type(source)
        HTTP::FormData::File.new(source, content_type: content_type)
      end

      def detect_content_type(source)
        return MimeMagic.by_magic(source) if source.is_a?(IO)
        MimeMagic.by_path(source.to_s)
      end
    end
  end
end
