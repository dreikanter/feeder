class BaseLoader
  Error = Class.new(StandardError)

  include Callee
  include Logging

  param :feed

  def call
    logger.info("---> loading feed [#{feed&.name}]")
    perform
  end

  protected

  def perform
    raise "not implemented"
  end
end
