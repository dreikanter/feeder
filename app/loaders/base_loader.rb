class BaseLoader
  def self.call(feed)
    new(feed).call
  end

  attr_reader :feed

  def initialize(feed)
    @feed = feed
  end

  def call
    raise "not implemented"
  end
end
