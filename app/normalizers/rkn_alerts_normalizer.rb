module Normalizers
  class RknAlertsNormalizer < Normalizers::Base
    protected

    # NOTE: Placeholder for a required field
    def link
      SecureRandom.uuid
    end

    def published_at
      Time.now.utc
    end

    def text
      result = []
      result << "#{blocked_amount} of #{total_amount} are currently blocked."
      result << blocked_ips if blocked.any?
      result << unblocked_ips if unblocked.any?
      result.join("\n")
    end

    private

    def blocked
      entity[:blocked]
    end

    def unblocked
      entity[:unblocked]
    end

    def total
      entity[:total_count]
    end

    def blocked_amount
      blocked.empty? ? 'None' : blocked.count
    end

    def total_amount
      raise 'total amount of servers should be positive' unless total.positive?
      ActionController::Base.helpers.pluralize(total, 'freefeed.net servers')
    end

    def blocked_ips
      "Recently blocked IPs: #{blocked.join(', ')}"
    end

    def unblocked_ips
      "Recently unblocked IPs: #{unblocked.join(', ')}"
    end
  end
end
