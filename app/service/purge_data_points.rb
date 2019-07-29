module Service
  class PurgeDataPoints
    include Callee

    DEFAULT_THRESHOLD = 3.month.ago.freeze

    option :threshold, default: -> { DEFAULT_THRESHOLD }

    def call
      DataPoint.where('created_at < ?', threshold).delete_all
    end
  end
end
