class ClassResolver
  attr_reader :class_name, :suffix

  def initialize(class_name, suffix:)
    @class_name = class_name
    @suffix = suffix
  end

  def resolve
    "#{class_name}_#{suffix}".classify.constantize
  rescue NameError
    nil
  end
end
