class FaultyProcessor < BaseProcessor
  def entities
    raise "test error"
  end
end
