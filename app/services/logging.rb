module Logging
  def logger
    @logger ||= ApplicationLogger.new(Rails.logger)
  end
end
