module Service
  class EntityNormalizer
    def self.for(name)
      name = name.to_s.gsub(/-/, '_')
      "entity_normalizers/#{name}_normalizer".classify.constantize
    rescue
      nil
    end
  end
end
