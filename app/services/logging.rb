module Logging
  def logger
    @logger ||= ApplicationLogger.new
  end
end
