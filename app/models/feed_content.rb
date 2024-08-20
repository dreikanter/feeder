# Data object for raw feed content representation. All loaders return
# a FeedContent instance.
#
# @see BaseLoader
#
class FeedContent
  attr_reader :content, :imported_at, :import_duration

  def initialize(content:, imported_at: Time.current, import_duration: 0)
    @content = content
    @imported_at = imported_at
    @import_duration = import_duration
  end

  def ==(other)
    other.is_a?(FeedContent) &&
      content == other.content &&
      imported_at == other.imported_at &&
      import_duration == other.import_duration
  end
end
