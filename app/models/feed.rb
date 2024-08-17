class Feed < ApplicationRecord
  def supported?
    !!(loader_class && processor_class && normalizer_class)
  end

  def service_classes
    {
      loader_class: loader_class,
      processor_class: processor_class,
      normalizer_class: normalizer_class
    }
  end

  def loader_class
    ClassResolver.new(loader, suffix: "loader").resolve
  rescue NameError
    nil
  end

  def loader_instance
    loader_class.new(self)
  end

  def processor_class
    ClassResolver.new(processor, suffix: "processor").resolve
  rescue NameError
    nil
  end

  def processor_instance
    processor_class.new(self)
  end

  def normalizer_class
    ClassResolver.new(normalizer, suffix: "normalizer").resolve
  rescue NameError
    nil
  end

  def normalizer_instance
    normalizer_class.new(self)
  end
end
