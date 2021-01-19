class LoaderResolver
  include Callee

  Error = Class.new(StandardError)

  param :feed
  option :logger, optional: true, default: -> { Rails.logger }

  DEFAULT_LOADER = HttpLoader

  def call
    return DEFAULT_LOADER unless loader_name.present?
    "#{loader_name}_loader".classify.constantize
  rescue NameError
    raise Error, name: loader_name
  end

  private

  def loader_name
    feed.loader.to_s
  end
end
