class ApplicationJob < ActiveJob::Base
  rescue_from StandardError do |exception|
    ErrorDumper.call(
      exception: exception,
      context: { class_name: self.class.name }
    )
  end
end
