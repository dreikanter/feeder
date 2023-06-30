class BaseLoader
  Error = Class.new(StandardError)

  include Callee

  param :feed

  def call
    raise "not implemented"
  end
end
