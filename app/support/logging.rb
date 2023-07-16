module Logging
  CLEAR = "\e[0m"
  BOLD = "\e[1m"

  BLACK = "\e[30m"
  RED = "\e[31m"
  GREEN = "\e[32m"
  YELLOW = "\e[33m"
  BLUE = "\e[34m"
  MAGENTA = "\e[35m"
  CYAN = "\e[36m"
  WHITE = "\e[37m"

  # :reek:UtilityFunction
  def logger
    Rails.logger
  end

  def log_debug(message)
    logger.debug(format_message(message, WHITE))
  end

  def log_info(message)
    logger.info(format_message(message, BLUE))
  end

  def log_warn(message)
    logger.warn(format_message(message, YELLOW))
  end

  def log_error(message)
    logger.error(format_message(message, RED))
  end

  private

  def format_message(message, color)
    return message unless colorize_logs?
    "#{color}#{message}#{CLEAR}"
  end

  def colorize_logs?
    ENV["COLOR_LOGS"].present?
  end
end
