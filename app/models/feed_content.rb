# Data object for raw feed content representation. All loaders return
# a FeedContent instance.
#
# @see BaseLoader
#
class FeedContent
  attr_reader :raw_content

  def initialize(raw_content)
    @raw_content = raw_content
  end
end
