module Normalizers
  class RknAlertsNormalizer < Normalizers::Base
    # NOTE: Placeholder for a required field
    def link
      SecureRandom.uuid
    end

    def published_at
      Time.now.utc
    end

    def text
      result = []
      blocked = entity[:blocked]
      result << "Recently blocked IPs: #{blocked.join(', ')}" if blocked.any?
      unblocked = entity[:unblocked]
      result << "Recently unblocked IPs: #{unblocked.join(', ')}" if unblocked.any?
      result.join("\n")
    end
  end
end
