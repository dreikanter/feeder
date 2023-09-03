class FaultyProcessor < BaseProcessor
  def process
    raise "test error"
  end
end
