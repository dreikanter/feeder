class PurgeErrors
  include Callee

  DEFAULT_THRESHOLD = 3

  option :threshold, default: -> { DEFAULT_THRESHOLD }

  def call
    Error.where("created_at < ?", threshold.month.ago).delete_all
  end
end
