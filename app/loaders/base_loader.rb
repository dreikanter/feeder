class BaseLoader
  include Callee

  param :feed
  option :logger, optional: true, default: -> { Rails.logger }

  def call
    logger.info("---> loading feed [#{feed&.name}]")
    perform
  end

  protected

  def perform
    raise 'not implemented'
  end
end
