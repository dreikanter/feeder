class Stopwatch
  attr_reader :start

  def self.measure(&block)
    instance = new
    block.call, instance.elapsed
  end

  def initialize
    @start = Time.current
  end

  def elapsed
    Time.current - start
  end
end
