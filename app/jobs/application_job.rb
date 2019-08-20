class ApplicationJob < ActiveJob::Base
  rescue_from StandardError do |exception|
    ErrorDumper.call(
      context: { class_name: self.class.name },
      exception: exception,
      target: arguments[0].is_a?(ActiveRecord::Base) ? arguments[0] : nil
    )
  end
end
