class ApplicationJob < ActiveJob::Base
  rescue_from StandardError do |exception|
    class_name = self.class.name
    logger.error("---> error in #{class_name}: #{exception.message}")
    Error.dump(exception, class_name: class_name)
  end
end
