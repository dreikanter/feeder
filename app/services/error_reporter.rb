# Hidrate new instance of error report with
class ErrorReporter
  # @param error: [Exception]
  # @params category: [String]
  # @param target: [ActiveRecord::Base] target record (optional)
  # @param context: [Hash] JSON-friendly arbitrary hash object (optional)
  # @param occured_at: [DateTime] error timestamp (optional)
  def report(error:, category:, **options)
    ErrorReport.create!(
      category: category,
      target: options[:target],
      context: options[:context] || {},
      occured_at: options[:occured_at] || Time.current,
      **error_details(error)
    )
  end

  private

  def error_details(error)
    {
      error_class: error.class.name,
      message: error.message,
      **backtrace_dtails(error.backtrace || [])
    }
  end

  def backtrace_dtails(backtrace)
    match = backtrace&.first&.match(/^(.+):(\d+):in/)

    if match
      {
        backtrace: backtrace,
        file_name: match[1],
        line_number: match[2].to_i
      }
    else
      {backtrace: backtrace}
    end
  end
end
