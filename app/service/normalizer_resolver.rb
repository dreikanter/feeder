module Service
  class NormalizerResolver
    include Callee

    param :feed

    def call
      raise 'existing feed is required' unless feed
      matching_normalizer
    end

    private

    def matching_normalizer
      available_names.each do |name|
        return normalizer_class_name(name)
      rescue NameError
        next
      end
      raise("no matching normalizer for '#{feed.name}'")
    end

    def normalizer_class_name(name)
      safe_name = name.to_s.gsub(/-/, '_')
      "normalizers/#{safe_name}_normalizer".classify.constantize
    end

    def available_names
      [feed.normalizer, feed.name, feed.processor].compact
    end
  end
end
