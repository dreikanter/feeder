class BaseLoader
  attr_reader :feed

  def initialize(feed)
    @feed = feed
  end

  def content
    raise AbstractMethodError
  end
end
