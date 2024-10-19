module Freefeed
  module V1
    module Attachments
      # @param [String, Pathname, IO] source could by a file path
      # or an IO object
      def create_attachment(source, content_type: nil)
        options = {form: {file: file(source, content_type)}}
        authenticated_request(:post, "/v1/attachments", options)
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
