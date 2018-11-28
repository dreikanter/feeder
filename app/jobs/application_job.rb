class ApplicationJob < ActiveJob::Base
  rescue_from StandardError do |exception|
    Rails.logger.error exception
    Error.dump(exception, class_name: self.class.name)
  end
end
