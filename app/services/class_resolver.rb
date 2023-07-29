class ClassResolver
  Error = Class.new(StandardError)

  include Logging

  attr_reader :class_name, :suffix

  def initialize(class_name, suffix: nil)
    @class_name = class_name
    @suffix = suffix
  end

  def resolve
    full_class_name.constantize
  rescue NameError => e
    raise Error, error_message, e.backtrace
  end

  private

  def error_message
    "error resolving class: name: #{class_name || "nil"}, suffix: #{suffix}"
  end

  def full_class_name
    [class_name, suffix].join("_").classify
  end
end
