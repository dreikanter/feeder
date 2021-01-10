class LoaderResolver
  include Callee

  param :feed
  option :logger, optional: true, default: -> { Rails.logger }

  DEFAULT_LOADER = 'http'.freeze

  def call
    return NullLoader unless feed.url
    matching_loader || raise("no matching loader for '#{feed.name}'")
  end

  private

  def matching_loader
    available_names.each do |name|
      safe_name = name.to_s.gsub(/-/, '_')
      result = "#{safe_name}_loader".classify.constantize
      logger.debug("loader resolved to [#{result}]")
      return result
    rescue StandardError
      next
    end
  end

  def available_names
    [
      feed.loader,
      feed.name,
      DEFAULT_LOADER
    ]
  end
end
