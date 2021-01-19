class LoaderResolver
  include Callee

  Error = Class.new(StandardError)

  param :feed
  option :logger, optional: true, default: -> { Rails.logger }

  DEFAULT_LOADER = HttpLoader

  def call
    explicit_loader_name = feed.loader.to_s
    return DEFAULT_LOADER unless explicit_loader_name.present?
    "#{explicit_loader_name}_loader".classify.constantize
  rescue NameError
    raise Error, name: feed.loader
  end
end
