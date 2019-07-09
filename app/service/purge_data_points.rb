module Service
  class PurgeDataPoints
    DEFAULT_THRESHOLD = 3.month.ago.freeze

    extend Dry::Initializer

    option :threshold, default: -> { DEFAULT_THRESHOLD }

    def self.call(options = {})
      new(options).call
    end

    def call
      DataPoint.where('created_at < ?', threshold).delete_all
    end
  end
end
