module Service
  class NormalizerResolver
    include Callee

    param :feed

    def call
      matching_normalizer || raise("no matching normalizer for '#{feed.name}'")
    end

    private

    def matching_normalizer
      available_names.each do |name|
        safe_name = name.to_s.gsub(/-/, '_')
        return "normalizers/#{safe_name}_normalizer".classify.constantize
      rescue NameError
        next
      end
    end

    def available_names
      [
        feed.normalizer,
        feed.name,
        feed.processor
      ]
    end
  end
end
