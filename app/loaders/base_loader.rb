class BaseLoader
  Error = Class.new(StandardError)

  include Callee
  include Logging

  param :feed

  def call
    raise NotImplementedError
  end
end
