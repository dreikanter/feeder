class ClassResolver
  include Logging

  attr_reader :class_name, :suffix

  def initialize(class_name, suffix: nil)
    @class_name = class_name
    @suffix = suffix
  end

  def resolve
    [class_name, suffix].join("_").classify.constantize
  end
end
