# ApplicationLogger is a wrapper for Ruby loggers that adds color formatting to
# log messages. Color formatting can be enabled or disabled, and it respects the
# NO_COLOR environment variable by default.
#
# Usage:
#   logger = ApplicationLogger.new
#   logger.info "This is an info message"
#   logger.info { "This line will be evaluated only if the logger" }
#
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

  def initialize(logger: Rails.logger, colorize: ENV["NO_COLOR"].blank?)
    @logger = logger
    @colorize = colorize
  end

  def debug(message = nil, &)
    log_formatted_message(:debug, message, WHITE, &)
  end

  def info(message = nil, &)
    log_formatted_message(:info, message, BLUE, &)
  end

  def warn(message = nil, &)
    log_formatted_message(:warn, message, YELLOW, &)
  end

  def error(message = nil, &)
    log_formatted_message(:error, message, RED, &)
  end

  def success(message = nil, &)
    log_formatted_message(:info, message, GREEN, &)
  end

  private

  def log_formatted_message(level, message, color, &block)
    if block
      logger.send(level, &-> { format_message(block.call, color) })
    else
      logger.send(level, format_message(message, color))
    end
  end

  def format_message(message, color)
    if colorize?
      "#{color}#{message}#{CLEAR}"
    else
      message
    end
  end

  def colorize?
    @colorize
  end
end
