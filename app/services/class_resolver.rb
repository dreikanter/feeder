class ClassResolver
  attr_reader :class_name, :suffix, :fallback

  def initialize(class_name, suffix: nil, fallback: nil)
    @class_name = class_name
    @suffix = suffix
    @fallback = fallback
  end

  def resolve
    [class_name, suffix].join("_").classify.constantize
  rescue NameError
    fallback || raise
  end
end
