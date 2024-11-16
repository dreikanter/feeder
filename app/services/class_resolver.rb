# Resolver a class from the class name and optional suffix.
#
class ClassResolver
  attr_reader :class_name, :suffix

  # @param [String] a string representing the target class name with words
  #   separated by underscores
  # @param suffix: [String] optional suffix for the class name
  def initialize(class_name, suffix: nil)
    @class_name = class_name
    @suffix = suffix
  end

  # @return [Class]
  # @raise [NameError] if the target class is missing
  def resolve
    [class_name, suffix].join("_").classify.constantize
  rescue NameError
    nil
  end
end
