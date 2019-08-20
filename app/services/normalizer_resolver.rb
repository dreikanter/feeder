class NormalizerResolver
  include Callee

  param :feed
  option :logger, optional: true, default: -> { Rails.logger }

  def call
    available_names.each do |name|
      result = normalizer_class_name(name)
      logger.debug("normalizer resolved to [#{result}]")
      return result
    rescue NameError
      next
    end
    raise "can not resolve normalizer for [#{feed&.name}] feed"
  end

  private

  def normalizer_class_name(name)
    safe_name = name.to_s.gsub(/-/, '_')
    "#{safe_name}_normalizer".classify.constantize
  end

  def available_names
    [feed.normalizer, feed.name, feed.processor].compact
  end
end
