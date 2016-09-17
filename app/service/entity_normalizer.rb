module Service
  class EntityNormalizer
    def self.for(name)
      "entity_normalizers/#{name}_normalizer".classify.constantize
    rescue
      nil
    end
  end
end
