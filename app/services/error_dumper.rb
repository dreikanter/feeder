class ErrorDumper
  include Callee

  UNDEFINED_EXCEPTION = "".freeze

  option :exception, optional: true, default: -> { UNDEFINED_EXCEPTION }
  option :file_name, optional: true, default: -> { extract_file_name }
  option :label, optional: true, default: -> { location.try(:label).to_s }
  option :line_number, optional: true, default: -> { extract_line_number }
  option :occured_at, optional: true, default: -> { DateTime.now }
  option :target, optional: true, default: -> {}
  option :context, optional: true, default: -> { {} }
  option :message, optional: true, default: -> { exception.try(:message) || exception.to_s }

  def call
    notify_honeybadger(exception, message)
    persist_error
  end

  private

  def persist_error
    Error.create!(
      backtrace: backtrace,
      context: context,
      exception: exception_name,
      file_name: file_name,
      label: label,
      line_number: line_number,
      message: message,
      occured_at: occured_at,
      target: target
    )
  rescue StandardError => e
    notify_honeybadger(e, "Error saving an Error")
  end

  def notify_honeybadger(error, error_message = nil)
    Honeybadger.notify(error, error_message: error_message)
  end

  def backtrace
    exception.try(:backtrace) || []
  end

  def exception_name
    return exception.try(:class).try(:name) if exception.is_a?(Exception)
    exception.to_s
  end

  def extract_line_number
    location.try(:lineno) || line_number_from_backtrace
  end

  def line_number_from_backtrace
    line = backtrace.first
    return unless line
    line.match(/:(\d+):/).captures.first.to_i
  end

  def extract_file_name
    location.try(:path).to_s || file_name_from_backtrace
  end

  def file_name_from_backtrace
    line = backtrace.first
    line&.gsub(/:\d+:.*$/, "")
  end

  def location
    exception.try(:locations).try(:first)
  end
end
