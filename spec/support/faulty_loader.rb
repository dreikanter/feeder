class FaultyLoader < BaseLoader
  def perform
    raise "test error"
  end
end
