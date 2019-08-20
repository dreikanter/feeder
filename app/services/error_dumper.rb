class ErrorDumper
  include Callee

  option :exception, optional: true, default: -> { nil }

  option :file_name, optional: true, default: -> { location.try(:path).to_s }
  option :label, optionsl: true, default: -> { location.try(:label).to_s }
  option :line_number, option: true, default: -> { location.try(:lineno) }
  option :occured_at, optional: true, default: -> { DateTime.now }
  option :target, optional: true, default: -> { nil }
  option :context, optional: true, default: -> { {} }

  option(
    :message,
    optional: true,
    default: -> { exception.try(:message) || exception.to_s }
  )

  def call
    Error.create!(
      backtrace: backtrace,
      context: context,
      exception: exception_class,
      file_name: file_name,
      label: label,
      line_number: line_number,
      message: message,
      occured_at: occured_at,
      status: ErrorStatus.pending,
      target: target
    )
  end

  def location
    exception.try(:locations).try(:first)
  end

  def backtrace
    exception.try(:backtrace) || []
  end

  def exception_class
    exception.try(:class).try(:name)
  end
end
