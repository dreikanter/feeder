class Callable
  extend Dry::Initializer

  def self.call(*args, **kwargs)
    new(*args, **kwargs).call
  end

  def call
    raise NotImplementedError
  end
end
