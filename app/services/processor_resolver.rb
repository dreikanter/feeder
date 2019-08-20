class ProcessorResolver
  include Callee

  param :feed
  option :logger, optional: true, default: -> { Rails.logger }

  def call
    available_names_for.each do |name|
      safe_name = name.to_s.gsub(/-/, '_')
      result = "#{safe_name}_processor".classify.constantize
      logger.debug("processor resolved to [#{result}]")
      return result
    rescue NameError
      next
    end
  end

  private

  FALLBACK_PROCESSOR = 'null'.freeze

  def available_names_for
    [
      feed.name,
      feed.processor,
      FALLBACK_PROCESSOR
    ]
  end
end
