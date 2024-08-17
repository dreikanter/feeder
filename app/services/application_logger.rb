class ApplicationLogger
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

  attr_reader :logger

  def initialize(logger)
    @logger = logger
  end

  def debug(message)
    logger.debug(format_message(message, WHITE))
  end

  def info(message)
    logger.info(format_message(message, BLUE))
  end

  def warn(message)
    logger.warn(format_message(message, YELLOW))
  end

  def error(message)
    logger.error(format_message(message, RED))
  end

  def success(message)
    logger.info(format_message(message, GREEN))
  end

  private

  def format_message(message, color)
    return message unless colorize?
    "#{color}#{message}#{CLEAR}"
  end

  def colorize?
    @colorize ||= ENV["NO_COLOR"].blank?
  end
end
